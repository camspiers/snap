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
                       config   snap.config
                       buffer   snap.common.buffer
                       window   snap.common.window
                       input    snap.view.input
                       results  snap.view.results
                       view     snap.view.view
                       request  snap.producer.request
                       create   snap.producer.create}
              require-macros [snap.macros]})

;; Exposes register as a main API
(def register register)

;; Exposes config as a main API
(def config config)

(defn map [key run opts]
  "Creates a mapping and an optional command name"
  (assertstring key "map key argument must be a string")
  (assertfunction run "map run argument must be a function")
  (local command (when (type opts)
    :string (do (print "[Snap API] The third argument to snap.map is now a table, treating passed string as command, this will be deprecated")
              opts)
    :table opts.command))
  (assertstring? command "map command argument must be a string")
  (register.map (if opts.modes opts.modes :n) key run)
  (when command (register.command command run)))

(defn maps [config]
  "Creates mappings"
  (each [_ [key run opts] (ipairs config)]
    (map key run opts)))

(defn get_producer [producer]
  "When a producer is a table, pull the default function out of it"
  (match (type producer)
    :table producer.default
    _ producer))

(defn get [mod]
  "Provides easy access to submodules"
  (require (string.format "snap.%s" mod)))

(defn sync [value]
  "Basic wrapper around coroutine.yield that returns first result"
  (assertfunction value "value passed to snap.sync must be a function")
  (select 2 (coroutine.yield value)))

;; Represents a request to yield for other processing
(def continue_value {:continue true})

(defn continue [on-cancel]
  "Yields for other processing or cancels if needed"
  (assertfunction? on-cancel "on-cancel provided to snap.continue must be a function")
  (coroutine.yield continue_value on-cancel))

(defn resume [thread request value]
  "Transfers sync values allowing the yielding of functions with non fast-api access"
  (assertthread thread "thread passed to snap.resume must be a thread")
  (let [(_ result) (coroutine.resume thread request value)]
    (if
      ;; If we are cancelling then return nil
      (request.canceled) nil
      ;; When we have a function, we want to yield it get the value then continue
      (= (type result) :function) (resume thread request (sync result))
      ;; If we aren't canceling then return result
      result)))

(defn consume [producer request]
  "Returns an iterator that consumes a producer"
  (local producer (get_producer producer))
  (assertfunction producer "producer passed to snap.consume must be a function")
  (asserttable request "request passed to snap.consume must be a table")
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
             (assertmetatable result meta_tbl "result has wrong metatable")
             result)
    _ (assert false "result passed to snap.meta_result must be a string or meta result")))

(defn with_meta [result field value]
  "Sets a meta field, e.g. score, positions"
  (assertstring field "field passed to snap.with_meta must be a string")
  (let [meta-result (meta_result result)]
    (tset meta-result field value)
    meta-result))

(defn with_metas [result metas]
  "Sets multiple meta values"
  (asserttable metas "metas passed to snap.with_metas must be a table")
  (let [meta-result (meta_result result)]
    (each [field value (pairs metas)]
      (tset meta-result field value))
    meta-result))

(defn has_meta [result field]
  "Determines whether a result has a meta field"
  (assertstring field "field passed to snap.has_meta must be a string")
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
  (asserttable config "snap.run config must be a table")
  (assertfunction
    (get_producer config.producer) "snap.run 'producer' must be a function or a table with a default function")
  (assertfunction config.select "snap.run 'select' must be a function")

  ;; Optional values
  (assertfunction? config.multiselect "snap.run 'multiselect' must be a function")
  (assertstring? config.prompt "snap.run 'prompt' must be a string")
  (assertfunction? config.layout "snap.run 'layout' must be a function")
  (asserttypes? [:boolean :function] config.hide_views "snap.run 'hide_views' must be a boolean or a function")
  (asserttable? config.views "snap.run 'views' must be a table")
  (when config.views
    (each [_ view (ipairs config.views)]
      (assertfunction view "snap.run each view in 'views' must be a function")))
  (assertfunction? config.loading "snap.run 'loading' must be a function")
  (assertboolean? config.reverse "snap.run 'reverse' must be a boolean")
  (assertstring? config.initial_filter "snap.run 'initial_filter' must be a string")

  ;; Store the last results
  (var last-results [])

  ;; Stores the last filter
  (var last-requested-filter "")

  ;; Stores the last selection
  (var last-requested-selection nil)

  ;; Exit flag tracks whether buffers have detatched
  ;; Used to send cancel request to producer coroutines
  (var exit false)

  ;; Default to the bottom layout
  (local layout (or config.layout (. (get :layout) :centered)))

  ;; Default to loading creator
  (local loading (or config.loading (get :loading)))

  ;; Store the initial filter
  (local initial-filter (or config.initial_filter ""))

  ;; Stores the original window to so we can pass it back to the select function
  (local original-winnr (vim.api.nvim_get_current_win))

  ;; Configures a default or custom prompt
  (local prompt (string.format "%s " (or config.prompt :Find>)))

  ;; Stores the selected items, used for multiselect
  (var selected {})

  ;; Store the cursor row
  (var cursor-row 1)

  ;; Starts as nil until manually overridden
  (var hide-views nil)

  ;; Computes default value or if hide-views is manually set then use that
  (fn get-hide-views []
    (if
      (not= hide-views nil)
      hide-views
      (not= config.hide_views nil)
      (match (type config.hide_views)
        :function (config.hide_views)
        :boolean config.hide_views)
      false))

  ;; Vars for storing all views
  (var input-view nil)
  (var results-view nil)
  (var views [])

  ;; Helper function for getting the line under the cursor
  (fn get-selection [] (. last-results cursor-row))

  ;; Handles exiting
  (fn on-exit []
    ;; Send the signal to exit to all potentially running processes in coroutines
    (set exit true)

    ;; Free memory
    (set last-results [])
    (set selected nil)
    (tset config :producer nil)
    (tset config :views nil)

    (each [_ {: view} (ipairs views)]
      (view:delete))
    (results-view:delete)
    (input-view:delete)

    ;; Close each window
    ;; Return back to original window
    (vim.api.nvim_set_current_win original-winnr)

    ;; Return back from insert mode
    (vim.api.nvim_command :stopinsert))

  ;; Calculate the total views
  (local total-views (if config.views (length config.views) 0))

  ;; Dynamic because we can hide and show views
  (fn has-views []
    (and
      (> total-views 0)
      (not (get-hide-views))))

  ;; Views need to be recreated when we hide/show
  (fn create-views []
    (when (has-views)
      (each [index producer (ipairs config.views)]
        (local view {:view (view.create {: layout : index : total-views}) : producer})
        (table.insert views view))))

  ;; Create the views
  (create-views)

  ;; Creates the results buffer and window and stores thier numbers
  (set results-view (results.create {: layout : has-views :reverse config.reverse}))

  ;; Helper to update cursor
  (fn update-cursor []
    (vim.api.nvim_win_set_cursor results-view.winnr [cursor-row 0]))

  ;; Updates the views based on selection
  (safedebounced update-views [selection]
    (each [_ {:view {: bufnr : winnr : width : height} : producer} (ipairs views)]
      (fn cancel [request]
        (or exit (not= (tostring request.selection) (tostring (get-selection)))))
      (local body {: selection : bufnr : winnr : width : height})
      (local request (request.create {: body : cancel}))
       ; TODO optimization, this should pass all the producers, not just one
       ; that way we can avoid creating multiple idle checkers
      (create {: producer : request})))

  ;; Only write what results are needed
  (safedebounced write-results [results force-views]
    (when (not exit)
      (let [result-size (length results)]
        ;; Make sure cursor stays in view
        (when (> cursor-row result-size) (set cursor-row (math.max 1 result-size)))
        (if (= result-size 0)
          ;; If there are no results then clear
          (do
           (buffer.set-lines results-view.bufnr 0 -1 [])
           (update-cursor))
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
            ;; Make sure the cursor is always updated
            (update-cursor)
            ;; Update highlights
            (each [row (pairs partial-results)]
              (local result (. results row))
              ;; Add positions highlighting
              (when
                (has_meta result :positions)
                (buffer.add-positions-highlight
                  results-view.bufnr
                  row
                  (match (type result.positions)
                    :table result.positions
                    :function (result:positions)
                    _ (assert false "result positions must be a table or function"))))
              ;; Add selected highlighting
              (when
                (. selected (tostring result))
                (buffer.add-selected-highlight results-view.bufnr row))))))

      ;; When we are running views schedule them
      (local selection (get-selection))
      (when
        (and (has-views) (or force-views (not= (tostring last-requested-selection) (tostring selection))))
        (set last-requested-selection selection)
        ;; Create new buffers
        ;; Each view gets a new buffer each selection change
        ;; Reusing buffers doesn't work well because it leads to strange performance problems
        ;; e.g. with treesitter, changing the filetype from one to another appears to cause pathological
        ;; performance issues
        (each [_ {: view} (ipairs views)]
          (local bufnr (buffer.create))
          (vim.api.nvim_win_set_buf view.winnr bufnr)
          (buffer.delete view.bufnr {:force true})
          (tset view :bufnr bufnr))
        (when (not= selection nil)
          (update-views selection)))))

  ;; On input update
  (fn on-update [filter]
    (set last-requested-filter filter)
    ;; Tracks if any results have rendered
    (var early-write false)
    ;; Store the number of times the loading screen has displayed
    (var loading-count 0)
    ;; Store the first time
    (local first-time (vim.loop.now))
    ;; Store a last-time time that updates on each loading screen render
    (var last-time first-time)
    ;; Accumulate results
    (var results [])
    ;; Create the cancel function
    (fn cancel [request] (or exit (not= request.filter last-requested-filter)))
    ;; Create the request body
    (local body {: filter :height results-view.height :winnr original-winnr})
    ;; Prepare the request
    (local request (request.create {: body : cancel}))
    ;; Prepare the scheduler config
    (local config {:producer (get_producer config.producer) : request})
    ;; Schedules a loading screen write
    (safedebounced write-loading []
      (when (not (request.canceled))
        (local loading-screen (loading results-view.width results-view.height loading-count))
        (buffer.set-lines results-view.bufnr 0 -1 loading-screen)))
    ;; Add on end handler
    (fn config.on-end []
      (if
        (= (length results) 0)
        (do
          (set last-results results)
          (write-results last-results))
        ;; When we have scores attached then sort
        (has_meta (tbl.first results) :score)
        ;; Sort the table as far as we need to display results
        (do
          (tbl.partial-quicksort
            results
            1
            (length results)
            (+ results-view.height cursor-row)
            #(> $1.score $2.score))
          ;; Store the last written results
          (set last-results results)
          ;; Schedule the write
          (write-results last-results)))
      ;; Free the results
      (set results []))
    ;; Runs on each tick to check if loading screen is needed
    (fn config.on-tick []
      ;; Store the current time
      (when (not early-write)
        ;; Render a basic loading screen based on time
        (local current-time (vim.loop.now))
        ;; Render first loading screen if no render has occured
        (when
          (or
            (and (= loading-count 0) (> (- current-time first-time) 100))
            (> (- current-time last-time) 500))
          (do
            (set loading-count (+ loading-count 1))
            (set last-time current-time)
            (write-loading)))))
    ;; Collects results progressively and renders early if possible
    (fn config.on-value [value]
      ;; Check the type
      (asserttable value "Main producer yielded a non-yieldable value")
      ;; Accumulate the results
      (when (> (length value) 0)
        (tbl.accumulate results value)
        ;; This is an optimization to begin writing unscored results
        ;; as early as we can
        (when (not (has_meta (tbl.first results) :score))
          ;; Early write
          (set early-write true)
          ;; Set the results to enable cursor
          (set last-results results)
          ;; Schedule write
          (write-results last-results))))
    ;; And off we go!
    (create config))

  ;; Handles entering
  (fn on-enter [type]
    (local selections (vim.tbl_keys selected))
    (if
      (= (length selections) 0)
      ;; Single select case
      (let [selection (get-selection)]
        (when (not= selection nil) (safecall config.select selection original-winnr type)))
      ;; Multiselect case
      config.multiselect (safecall config.multiselect selections original-winnr)))

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
      (set cursor-row index)
      (update-cursor)
      (write-results last-results)))

  ;; On up handler
  (fn on-prev-item [] (on-key-direction #(- $1 1)))

  ;; On down handler
  (fn on-next-item [] (on-key-direction #(+ $1 1)))
 
  ;; Page up handler
  (fn on-prev-page [] (on-key-direction #(- $1 results-view.height)))

  ;; Page down handler
  (fn on-next-page [] (on-key-direction #(+ $1 results-view.height)))

  ;; Moves the view position
  (fn set-next-view-row [next-index]
    (when (has-views)
      (local {:view {: winnr : bufnr : height}} (tbl.first views))
      (let [line-count (vim.api.nvim_buf_line_count bufnr)
            [row] (vim.api.nvim_win_get_cursor winnr)
            index (math.max 1 (math.min line-count (next-index row height)))]
        (vim.api.nvim_win_set_cursor winnr [index 0]))))

  ;; View page up handler
  (fn on-viewpageup [] (when (has-views) (set-next-view-row #(- $1 $2))))

  ;; View page down handler
  (fn on-viewpagedown [] (when (has-views) (set-next-view-row #(+ $1 $2))))

  ;; Allows a series of steps
  (fn on-next []
    (when
      (or config.next (and config.steps (> (length config.steps) 0)))
      (local results last-results)
      (local next-config {})
      (each [key value (pairs config)]
        (tset next-config key value))
      (local next (or config.next (table.remove config.steps)))
      ;; handle next step
      (safecall (fn []
        (match (type next)
          :function (tset next-config :producer (next (fn [] results)))
          :table (do
            (each [key value (pairs next.config)]
              (tset next-config key value))
            (tset
              next-config
              :producer
              (if
                next.format
                (next.consumer (next.format results))
                (next.consumer (fn [] results))))))
         (run next-config)))))

  (fn on-view-toggle-hide []
    (set hide-views (if
      (= hide-views nil)
      (not (get-hide-views))
      (not hide-views)))
    (results-view:update)
    (input-view:update)
    (if hide-views
      (do
        (each [_ {: view} (ipairs views)]
          (view:delete))
        (set views []))
      (do
        (create-views)
        (vim.api.nvim_set_current_win input-view.winnr)
        (write-results last-results true))))

  ;; Initializes the input view
  ;; This is where all the key bindings happen
  (set input-view (input.create
    {:reverse config.reverse
     :mappings config.mappings
     : has-views
     : layout
     : prompt
     : on-enter
     : on-next
     : on-exit
     : on-prev-item
     : on-next-item
     : on-prev-page
     : on-next-page
     : on-viewpageup
     : on-viewpagedown
     : on-view-toggle-hide
     : on-select-toggle
     : on-select-all-toggle
     : on-update}))

  ;; Feed the initial filer to the input
  (when (not= initial-filter "")
    ;; We do it this way because prompts are broken in nvim
    (vim.api.nvim_feedkeys initial-filter :n false))

  nil)

(defn create [config defaults]
  "Creates a function that will run snap with the following config"
  (assertfunction config "Config must be a function")
  (fn [] (run (tbl.merge (or defaults {}) (config)))))
