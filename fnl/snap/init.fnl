;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                            ;;
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  Snap   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ;;
;;                                                                            ;;
;;          "except possibly one, who, if certain rumors were true            ;;
;;                might have done it by snapping his fingers"                 ;;
;;                                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                            ;;
;; ~~~~~~~~~~~ A small fast extensible finder system for neovim. ~~~~~~~~~~~~ ;;
;;                                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                            ;;
;; Example:                                                                   ;;
;;                                                                            ;;
;; (snap.run {:prompt "Print One or Two"                                      ;;
;;            :producer (fn [] [:One :Two])                                   ;;
;;            :select print})                                                 ;;
;;                                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(module snap {require {tbl      snap.common.tbl
                       register snap.common.register
                       buffer   snap.common.buffer
                       input    snap.view.input
                       results  snap.view.results
                       view     snap.view.view
                       request  snap.producer.request
                       create   snap.producer.create}})

;; Exposes register as a main API
(def register register)

(defn get [mod]
  "Provides easy access to submodules"
  (require (string.format "snap.%s" mod)))

(defn sync [value]
  "Basic wrapper around coroutine.yield that returns first result"
  (let [(_ result) (coroutine.yield value)]
    result))

;; Represents a request to yield for other processing
(def continue_value {:continue true})

(defn continue [on-cancel]
  "Yields for other processing or cancels if needed"
  (coroutine.yield continue_value on-cancel))

(defn resume [thread request value]
  "Transfers sync values allowing the yielding of functions with non fast-api access"
  (let [(_ result) (coroutine.resume thread request value)]
    (if
      ;; If we are cancelling then return nil
      (request.canceled) nil
      ;; When we have a function, we want to yield it
      ;; get the value then continue
      (= (type result) :function) (resume thread request (sync result))
      ;; If we aren't canceling then return result
      result)))

(defn consume [producer request]
  "Returns an iterator that consumes a producer"
  (var reader (coroutine.create producer))
  (fn []
    (if
      (= (coroutine.status reader) :dead)
      (set reader nil)
      (values (resume reader request)))))

;; Metatable for a result, allows the representation of results as both strings
;; and tables with extra data
(def meta_tbl {:__tostring #$1.result})

(defn meta_result [result]
  "Turns a result into a meta result"
  (match (type result)
    :string (let [meta-result {: result}]
              (setmetatable meta-result meta_tbl)
              meta-result)
    :table (do
             (assert (= (getmetatable result) meta_tbl))
             result)))

(defn with_meta [result field value]
  "Sets a meta field like score"
  (let [meta-result (meta_result result)]
    (tset meta-result field value)
    meta-result))

(defn with_metas [result data]
  "Sets multiple meta values"
  (let [meta-result (meta_result result)]
    (each [field value (pairs data)]
      (tset meta-result field value))
    meta-result))

(defn has_meta [result field]
  "Basic function for detecting metafield"
  (and (= (getmetatable result) meta_tbl) (not= (. result field) nil)))

;; Run docs:
;;
;; @config: {
;;   "Get the results to display"
;;   :producer (request: Request) => yield<Yieldable>
;;
;;   "Called when value is selected"
;;   :select () => void
;;
;;   "The prompt displayed to the user"
;;   :prompt string
;;
;;   "How to display the search results"
;;   :?layout (columns lines) => {
;;     :width number
;;     :height number
;;     :row number
;;     :col number
;;   }
;;
;;   "An optional function that enables multiselect executes on multiselect"
;;   :?multiselect (selections) => void
;;
;;   "An option table of additional views"
;;   :?views table<(request: SelectionRequest) => yiela<Yieldable>>
;;
;;   "An option function for creating loading screens"
;;   :?loading (width height counter) => table<string>
;; }
(defn run [config]
  "The main entry point for running snaps"
  ;; Required values
  (assert
    (= (type config) "table")
    "snap.run config must be a table")
  (assert
    config.producer
    "snap.run config must have a producer")
  (assert
    (= (type config.producer) "function")
    "snap.run 'producer' must be a function")
  (assert
    config.select
    "snap.run config must have a select")
  (assert
    (= (type config.select) "function")
    "snap.run 'select' must be a function")

  ;; Optional values
  (when config.multiselect
    (assert
      (= (type config.multiselect) "function")
      "snap.run 'multiselect' must be a function"))
  (when config.prompt
    (assert
      (= (type config.prompt) "string")
      "snap.run 'prompt' must be a string"))
  (when config.layout
    (assert
      (= (type config.layout) "function")
      "snap.run 'layout' must be a function"))
  (when config.views
    (assert
      (= (type config.views) "table")
      "snap.run 'views' must be a table")
    (each [_ view (ipairs config.views)]
      (assert
        (= (type view) "function")
        "snap.run each view in 'views' must be a function")))
  (when config.loading
    (assert
      (= (type config.loading) "function")
      "snap.run 'loading' must be a function"))

  ;; Store the last results
  (var last-results [])

  ;; Stores the last filter
  (var last-requested-filter "")

  ;; Stores the last selection
  (var last-requested-selection nil)

  ;; Exit flag tracks whether buffers have detatched
  ;; Used to send cancel request to producer coroutines
  (var exit false)

  ;; Store buffers for exiting
  (local buffers [])

  ;; Default to the bottom layout
  (local layout (or config.layout (. (get :layout) :centered)))

  ;; Default to loading creator
  (local loading (or config.loading (get :loading)))

  ;; Store the initial filter
  (local initial-filter (or config.initial_filter ""))

  ;; Stores the original window to so we can pass it back to the select function
  (local original-winnr (vim.api.nvim_get_current_win))

  ;; Configures a default or custom prompt
  (local prompt (string.format "%s> " (or config.prompt :Find)))

  ;; Stores the selected items, used for multiselect
  (var selected {})

  ;; Store the cursor row
  (var cursor-row 1)

  ;; Handles exiting
  (fn on-exit []
    ;; Send the signal to exit to all potentially running processes in coroutines
    (set exit true)

    ;; Free memory
    (set last-results [])
    (set selected nil)
    (tset config :producer nil)
    (tset config :views nil)

    ;; Return back to original window
    (vim.api.nvim_set_current_win original-winnr)

    ;; Delete each open buffer
    (each [_ bufnr (ipairs buffers)]
      (when (vim.api.nvim_buf_is_valid bufnr)
        (buffer.delete bufnr {:force true})))

    ;; Return back from insert mode
    (vim.api.nvim_command :stopinsert))

  ;; Create requested views
  (local total-views (if config.views (length config.views) 0))
  (local has-views (> total-views 0))
  (local views [])
  (when has-views
    (each [index producer (ipairs config.views)]
      (local view {:view (view.create {: layout : index : total-views}) : producer})
      (table.insert views view)
      (table.insert buffers view.view.bufnr)))

  ;; Creates the results buffer and window and stores thier numbers
  (local results-view (results.create {: layout : has-views}))

  ;; Register buffer for exiting
  (table.insert buffers results-view.bufnr)

  ;; Helper function for getting the line under the cursor
  (fn get-selection [] (. last-results cursor-row))

  ;; Only write what results are needed
  (fn write-results [results]
    (when (not exit)
      (let [result-size (length results)]
        (if (= result-size 0)
          ;; If there are no results then clear
          (buffer.set-lines results-view.bufnr 0 -1 [])
          ;; Otherwise render partial results
          ;; Don't render more than we need to
          ;; this is getting only the height plus the cursor
          (let [max (+ results-view.height cursor-row)
                partial-results []]
            (each [_ result (ipairs results)
                   :until (= max (length partial-results))]
              (table.insert partial-results (tostring result)))
            ;; Set the lines, but make sure tables are converted to strings
            (buffer.set-lines results-view.bufnr 0 -1 partial-results)
            ;; Update highlights
            (each [row _ (pairs partial-results)]
              (local result (. results row))
              ;; Add positions highlighting
              (when
                (has_meta result :positions)
                (buffer.add-positions-highlight
                  results-view.bufnr
                  row
                  result.positions))
              ;; Add selected highlighting
              (when
                (. selected (tostring result))
                (buffer.add-selected-highlight
                  results-view.bufnr
                  row)))))
        ;; Make sure cursor stays in view
        (when (> cursor-row result-size) (set cursor-row (math.max 1 result-size))))

      ;; When we are running views schedule them
      (local selection (get-selection))
      (when
        (and has-views (not= (tostring last-requested-selection) (tostring selection)))
        (set last-requested-selection selection)
        ;; Create new buffers
        (each [_ {: view} (ipairs views)]
          (local bufnr (buffer.create))
          (table.insert buffers bufnr)
          (vim.api.nvim_win_set_buf view.winnr bufnr)
          (buffer.delete view.bufnr {:force true})
          (tset view :bufnr bufnr))
        (when (not= selection nil)
          (vim.schedule (fn []
            (each [_ {:view {: bufnr : winnr : width : height} : producer} (ipairs views)]
              (fn cancel [request]
                (or exit (not= (tostring request.selection) (tostring (get-selection)))))
              (local body {: selection : bufnr : winnr : width : height})
              (local request (request.create {: body : cancel}))
               ; TODO optimization, this should pass all the producers, not just one
               ; that way we can avoid creating multiple idle checkers
              (create {: producer : request}))))))))

  ;; On input update
  (fn on-update [filter]
    (set last-requested-filter filter)
    ;; Tracks if any results have rendered
    (var has-rendered false)
    ;; Store the number of times the loading screen has displayed
    (var loading-count 0)
    ;; Store the first time
    (var last-time (vim.loop.now))
    ;; Accumulate results
    (var results [])
    ;; Create the cancel function
    (fn cancel [request] (or exit (not= request.filter last-requested-filter)))
    ;; Create the request body
    (local body {: filter :height results-view.height :winnr original-winnr})
    ;; Prepare the request
    (local request (request.create {: body : cancel}))
    ;; Prepare the scheduler config
    (local config {:producer config.producer : request})
    ;; Schedules a write, this can be partial results
    (fn schedule-results-write [results]
      ;; Update that we have rendered
      (set has-rendered true)
      (vim.schedule (partial write-results results)))
    ;; Schedules a loading screen write
    (fn schedule-loading-write []
      (set loading-count (+ loading-count 1))
      (vim.schedule (fn []
        (when (not (request.canceled))
          (local loading-screen (loading results-view.width results-view.height loading-count))
          (buffer.set-lines results-view.bufnr 0 -1 loading-screen)))))
    ;; Add on end handler
    (fn config.on-end []
      ;; When we have scores attached then sort
      (when
        (has_meta (tbl.first results) :score)
        (tbl.partial-quicksort
          results
          1
          (length results)
          (+ results-view.height cursor-row)
          #(> $1.score $2.score)))
      ;; Store the last written results
      (set last-results results)
      ;; Schedule the write
      (schedule-results-write last-results)
      ;; Free the results
      (set results []))

    ;; Add on value handler
    (fn config.on-value [value]
      ;; Check the type
      (assert (= (type value) :table) "Main producer yielded a non-yieldable value")
      ;; Store the current time
      (local current-time (vim.loop.now))
      ;; Accumulate the results
      (when (> (length value) 0)
        (tbl.accumulate results value))
      ;; This is an optimization to begin writing unscored results
      ;; as early as we can
      (when (and
              (= (length last-results) 0)
              (>= (length results) results-view.height)
              (not (has_meta (tbl.first results) :score)))
        ;; Set the results to enable cursor
        (set last-results results)
        ;; Early write
        (schedule-results-write results))
      ;; Render first loading screen if no render has occured, we have results
      ;; and no time based loading screen has rendered
      (when
        (and
          (not has-rendered)
          (= loading-count 0)
          (> (length results) 0))
        (schedule-loading-write))
      ;; Render a basic loading screen based on time
      (when
        (and
          (not has-rendered)
          (> (- current-time last-time) 500))
        (set last-time current-time)
        (schedule-loading-write)))

    ;; And off we go!
    (create config))

  ;; Handles entering
  (fn on-enter []
    (local selected-values (vim.tbl_keys selected))
    (if (= (length selected-values) 0)
      (let [selection (get-selection)]
        (when (not= selection nil)
          (vim.schedule (partial config.select selection original-winnr))))
      (when
        config.multiselect
        (vim.schedule (partial config.multiselect selected-values original-winnr)))))

  ;; Handles select all in the multiselect case
  (fn on-select-all-toggle []
    (when config.multiselect
      (each [_ value (ipairs last-results)]
        (let [value (tostring value)]
          (if (. selected value)
            (tset selected value nil)
            (tset selected value true))))
      (write-results last-results)))

  ;; Handles select in the multiselect case
  (fn on-select-toggle []
    (when config.multiselect
      (let [selection (get-selection)]
        (when (not= selection nil)
          (local value (tostring selection))
          (if (. selected value)
            (tset selected value nil)
            (tset selected value true))))))

  ;; On key helper
  (fn on-key-direction [next-index]
    (let [line-count (vim.api.nvim_buf_line_count results-view.bufnr)
          ;; Ensures cursor stays in results
          index (math.max 1 (math.min line-count (next-index cursor-row)))]
      (vim.api.nvim_win_set_cursor results-view.winnr [index 0])
      (set cursor-row index)
      (write-results last-results)))

  ;; On up handler
  (fn on-up []
    (on-key-direction #(- $1 1)))

  ;; On down handler
  (fn on-down []
    (on-key-direction #(+ $1 1)))
 
  ;; Page up handler
  (fn on-pageup []
    (on-key-direction #(- $1 results-view.height)))

  ;; Page down handler
  (fn on-pagedown []
    (on-key-direction #(+ $1 results-view.height)))

  ;; Moves the view position
  (fn set-next-view-row [next-index]
    (when has-views
      (local {:view {: winnr : bufnr : height}} (tbl.first views))
      (let [line-count (vim.api.nvim_buf_line_count bufnr)
            [row] (vim.api.nvim_win_get_cursor winnr)
            index (math.max 1 (math.min line-count (next-index row height)))]
        (vim.api.nvim_win_set_cursor winnr [index 0]))))

  ;; View page up handler
  (fn on-viewpageup []
    (when has-views
      (set-next-view-row #(- $1 $2))))

  ;; View page down handler
  (fn on-viewpagedown []
    (when has-views
      (set-next-view-row #(+ $1 $2))))

  ;; Initializes the input view
  ;; This is where all the key bindings happen
  (local input-view-info (input.create
    {: has-views
     : layout
     : prompt
     : on-enter
     : on-exit
     : on-up
     : on-down
     : on-pageup
     : on-pagedown
     : on-viewpageup
     : on-viewpagedown
     : on-select-toggle
     : on-select-all-toggle
     : on-update}))

  ;; Register buffer for exiting
  (table.insert buffers input-view-info.bufnr)

  ;; Feed the initial filer to the input
  (when (not= initial-filter "")
    ;; We do it this way because prompts are broken in nvim
    (vim.api.nvim_feedkeys initial-filter :n false))

  nil)

