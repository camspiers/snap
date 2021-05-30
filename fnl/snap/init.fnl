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

(module snap)

;; Local helpers

;; Basic helper to get the first value
(fn tbl-first [tbl]
  (when tbl
    (. tbl 1)))

;; Partition for quick sort
(fn partition [tbl p r comp]
  (let [x (. tbl r)]
    (var i (- p 1))
    (for [j p (- r 1) 1]
      (when (comp (. tbl j) x)
        (set i (+ i 1))
        (local temp (. tbl i))
        (tset tbl i (. tbl j))
        (tset tbl j temp)))
    (local temp (. tbl (+ i 1)))
    (tset tbl (+ i 1) (. tbl r))
    (tset tbl r temp)
    (+ i 1)))

;; Implementation of partial quicksort
;; For large amounts of results we can skip sorting the entire table

;; fnlfmt: skip
(fn partial-quicksort [tbl p r m comp]
  (when (< p r)
    (let [q (partition tbl p r comp)]
      (partial-quicksort tbl p (- q 1) m comp)
      (when (< p (- m 1))
        (partial-quicksort tbl (+ q 1) r m comp)))))

;; Public API

;; Provides easy access to submodules
(defn get [mod]
  (require (string.format "snap.%s" mod)))

;; Accumulates non empty results

;; fnlfmt: skip
(defn accumulate [results partial-results]
  (when (not= partial-results nil)
    (each [_ value (ipairs partial-results)]
      (when (not= (tostring value) "")
        (table.insert results value)))))

;; fnlfmt: skip
(defn sync [value]
  "Basic wrapper around coroutine.yield that returns first result"
  (let [(_ result) (coroutine.yield value)]
    result))

;; Represents a request to yield for other processing
(local continue-value {:continue true})
(defn continue [on-cancel]
  "Yields for other processing or cancels if needed"
  (coroutine.yield continue-value on-cancel))

;; fnlfmt: skip
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

;; fnlfmt: skip
(defn consume [producer request]
  "Returns an iterator that consumes a producer"
  (let [reader (coroutine.create producer)]
    (fn []
      (when (not= (coroutine.status reader) :dead)
        (values (resume reader request))))))


;; Metatable for a result, allows the representation of results as both strings
;; and tables with extra data
(def meta-tbl {:__tostring #$1.result})

;; Turns a result into a meta result

;; fnlfmt: skip
(defn meta_result [result]
  (match (type result)
    :string (let [meta-result {: result}]
              (setmetatable meta-result meta-tbl)
              meta-result)
    :table (do
             (assert (= (getmetatable result) meta-tbl))
             result)))

;; Sets a meta field like score

;; fnlfmt: skip
(defn with_meta [result field value]
  (let [meta-result (meta_result result)]
    (tset meta-result field value)
    meta-result))

;; Basic function for detecting metafield

;; fnlfmt: skip
(defn has_meta [result field]
  (and (= (getmetatable result) meta-tbl) (not= (. result field) nil)))

;; Stores mappings for buffers and global user mappings
(def register {})

;; Cleans up unneeded buffer maps
(fn register.clean [group]
  (tset register group nil))

;; Provides ability to run fn
(fn register.run [group fnc]
  (when (?. register group fnc)
    ((. register group fnc))))

(fn register.get-by-template [group fnc pre post]
  (let [group-fns (or (. register group) [])
        id (string.format "%s" fnc)]
    (tset register group group-fns)
    (when (= (. group-fns id) nil)
      (tset group-fns id fnc))
    (string.format "%slua require'snap'.register.run('%s', '%s')%s" pre group id post)))

;; Generates call signiture for maps
(fn register.get-map-call [group fnc]
  (register.get-by-template group fnc :<Cmd> :<CR>))

;; Generates call signiture for autocmds
(fn register.get-autocmd-call [group fnc]
  (register.get-by-template group fnc ":" ""))

;; Creates a buffer mapping and creates callable signiture
(fn register.buf_map [bufnr modes keys fnc opts]
  (let [rhs (register.get-map-call (tostring bufnr) fnc)]
    (each [_ key (ipairs keys)]
      (each [_ mode (ipairs modes)]
        (vim.api.nvim_buf_set_keymap bufnr mode key rhs (or opts {}))))))

;; Creates a global mapping
(fn register.map [modes keys fnc opts]
  (let [rhs (register.get-map-call "global" fnc)]
    (each [_ key (ipairs keys)]
      (each [_ mode (ipairs modes)]
        (vim.api.nvim_set_keymap mode key rhs (or opts {}))))))

;; View Helpers

;; Represents the bottom border
(local border-size 1)

;; Padding between ui elements
(local padding-size 1)

;; Percentage size that views should take up
(local views-width 0.5)

;; Used for allocating all total in a number of parts without remainder
(fn allocate [total parts]
  (var remaining total)
  (local sizes [])
  (local size (math.floor (/ total parts)))
  (for [i 1 parts]
    (if
      (= i parts)
      (table.insert sizes remaining)
      (do
        (table.insert sizes size)
        (set remaining (- remaining size)))))
  sizes)

;; Takes 
(fn take [tbl num]
  [(unpack tbl 1 num)])

;; Table sum
(fn sum [tbl]
  (var count 0)
  (each [_ val (ipairs tbl)]
    (set count (+ count val)))
  count)

;; Modifies the basic window options to make the input sit below
(fn create-input-layout [config]
  (let [{: width : height : row : col} (config.layout)]
    {:width (if config.has-views (math.floor (* width views-width)) width)
     :height 1
     :row (- (+ row height) padding-size)
     : col :focusable true}))

;;  Compute the results layout
(fn create-results-layout [config]
  (let [{: width : height : row : col} (config.layout)]
    {:width (if config.has-views (math.floor (* width views-width)) width)
     :height (- height border-size border-size padding-size)
     : row
     : col
     :focusable false}))

;;  Compute the view layout
(fn create-view-layout [config]
  (let [{: width : height : row : col} (config.layout)
        index (- config.index 1)
        border (* index border-size)
        padding (* index padding-size)
        total-borders (* (- config.total-views 1) border-size)
        total-paddings (* (- config.total-views 1) padding-size)
        sizes (allocate (- height total-borders total-paddings) config.total-views)
        height (. sizes config.index)
        col-offset (math.floor (* width views-width))]
    {:width (- width col-offset)
     : height
     :row (+ row (sum (take sizes index)) border padding)
     :col (+ col col-offset (* border-size 2) padding-size)
     :focusable false}))

;; Creates a scratch buffer, used for both results and input
(fn create-buffer []
  (vim.api.nvim_create_buf false true))

;; Creates a window with specified options

;; fnlfmt: skip
(fn create-window [bufnr {: width : height : row : col : focusable}]
  (vim.api.nvim_open_win bufnr 0 {: width
                          : height
                          : row
                          : col
                          : focusable
                          :relative :editor
                          :anchor :NW
                          :style :minimal
                          :border ["╭" "─" "╮" "│" "╯" "─" "╰" "│"]}))

;; Creates the results buffer and window

;; fnlfmt: skip
(fn create-results-view [config]
  (let [bufnr (create-buffer)
        layout (create-results-layout config)
        winnr (create-window bufnr layout)]
    (vim.api.nvim_win_set_option winnr :cursorline true)
    (vim.api.nvim_win_set_option winnr :wrap false)
    (vim.api.nvim_buf_set_option bufnr :buftype :prompt)
    {: bufnr : winnr :height layout.height :width layout.width}))

(fn create-view [config]
  (let [bufnr (create-buffer)
        layout (create-view-layout config)
        winnr (create-window bufnr layout)]
    (vim.api.nvim_win_set_option winnr :cursorline false)
    (vim.api.nvim_win_set_option winnr :wrap false)
    (vim.api.nvim_buf_set_option bufnr :filetype :on)
    {: bufnr : winnr :height layout.height :width layout.width}))

;; Creates the input buffer

;; fnlfmt: skip
(fn create-input-view [config]
  (let [bufnr (create-buffer)
        layout (create-input-layout config)
        winnr (create-window bufnr layout)]
    (vim.api.nvim_buf_set_option bufnr :buftype :prompt)
    (vim.fn.prompt_setprompt bufnr config.prompt)
    (vim.api.nvim_command :startinsert)

    (when (~= config.initial_filter "")
      ;; We do it this way because prompts are broken in nvim
      (vim.api.nvim_feedkeys config.initial_filter :n false))

    (fn get-filter []
      (let [contents (tbl-first (vim.api.nvim_buf_get_lines bufnr 0 1 false))]
        (if contents (contents:sub (+ (length config.prompt) 1)) "")))

    ;; Track exit
    (var exited false)

    (fn on-exit []
      (when (not exited)
        (set exited true)
        (config.on-exit)))

    (fn on-enter []
      (config.on-enter)
      (config.on-exit))

    (fn on-tab []
      (config.on-select-toggle)
      (config.on-down))

    (fn on-shifttab []
      (config.on-select-toggle)
      (config.on-up))

    (fn on-ctrla []
      (config.on-select-all-toggle))

    (local on_lines (fn []
      (config.on-update (get-filter))))

    (fn on_detach [] 
      (register.clean bufnr))

    (register.buf_map bufnr [:n :i] [:<CR>] on-enter)
    (register.buf_map bufnr [:n :i] [:<Up> :<C-k> :<C-p>] config.on-up)
    (register.buf_map bufnr [:n :i] [:<Down> :<C-j> :<C-n>] config.on-down)
    (register.buf_map bufnr [:n :i] [:<Esc> :<C-c>] on-exit)
    (register.buf_map bufnr [:n :i] [:<Tab>] on-tab)
    (register.buf_map bufnr [:n :i] [:<S-Tab>] on-shifttab)
    (register.buf_map bufnr [:n :i] [:<C-a>] on-ctrla)
    (register.buf_map bufnr [:n :i] [:<C-d>] config.on-pagedown)
    (register.buf_map bufnr [:n :i] [:<C-u>] config.on-pageup)

    (vim.api.nvim_command
      (string.format
        "autocmd! WinLeave <buffer=%s> %s"
        bufnr
        (register.get-autocmd-call (tostring bufnr) on-exit)))

    (vim.api.nvim_buf_attach bufnr false {: on_lines : on_detach})

    {: bufnr : winnr}))

(fn center-with-text-width [text text-width width]
  (let [space (string.rep " " (/ (- width text-width) 2))]
    (.. space text space)))

;; Center text for loading screen
(fn center [text width]
  (center-with-text-width text (string.len text) width))

;; Create a basic loading screen

;; fnlfmt: skip
(fn create-loading-screen [width height counter]
  (local dots (string.rep "." (% counter 5)))
  (local space (string.rep " " (- 5 (string.len dots))))
  (local loading-with-dots (.. "│" space dots " Loading " dots space "│")) 
  (local text-width (string.len loading-with-dots))
  (local loading [])

  (for [_ 1 (/ height 2)]
    (table.insert loading ""))

  (table.insert loading
    (center-with-text-width (.. "╭" (string.rep "─" 19) "╮") text-width width))
  (table.insert loading (center loading-with-dots width))
  (table.insert loading
    (center-with-text-width (.. "╰" (string.rep "─" 19) "╯") text-width width))
  loading)

;; Creates an api for handling slow values
(fn create-slow-api []
  (local slow-api {:pending false :value nil})
  (fn slow-api.schedule [fnc]
    (tset slow-api :pending true)
    (vim.schedule (fn []
      (tset slow-api :value (fnc))
      (tset slow-api :pending false))))
  (fn slow-api.free [] (tset slow-api :value nil))
  slow-api)

;; Schedules a view for generation
(fn schedule-producer [{: producer
                        : request
                        : on-end
                        : on-value}]
  ;; By the time the routine runs, we might be able to avoid it
  (when (not (request.canceled))
    (let [
          ;; Create the idle loop
          idle (vim.loop.new_idle)
          ;; Create the producer
          thread (coroutine.create producer)
          ;; Tracks the requests of slow nvim calls
          slow-api (create-slow-api)
          ;; Handle ending the idle loop and optionally calling on end
          stop (fn [] (idle:stop) (when on-end (on-end)))]

      ;; Start the checker after each IO poll
      (idle:start (fn []
        (if
          ;; Only run when we aren't waiting for a slow-api call
          slow-api.pending
          ;; Return nil
          nil
          ;; When the thread is not dead
          (not= (coroutine.status thread) :dead)
          ;; Run the resume
          (do
            ;; Fetches results be also sends cancel signal
            (let [(_ value on-cancel) (coroutine.resume thread request slow-api.value)]
              ;; Free memory
              (when slow-api.value (slow-api.free))
              ;; Match each type
              (match (type value)
                ;; We have a function so schedule it to be computed
                :function (slow-api.schedule value)
                :nil (stop)
                (where :table (= value continue-value))
                  (if
                    (request.canceled)
                    (do
                      (when on-cancel (on-cancel))
                      (stop))
                    nil)
                _ (when on-value (on-value value)))))
          ;; When the coroutine is dead then stop the loop
          (stop)))))))

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
;; }

;; fnlfmt: skip
(defn run [config]
  ;; Config validation

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

  ;; Store the initial filter
  (local initial_filter (or config.initial_filter ""))

  ;; Creates a namespace for highlighting
  (local namespace (vim.api.nvim_create_namespace :Snap))

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

    ;; Return back to original window
    (vim.api.nvim_set_current_win original-winnr)

    ;; Delete each open buffer
    (each [_ bufnr (ipairs buffers)]
      (when (vim.api.nvim_buf_is_valid bufnr)
        (vim.api.nvim_buf_delete bufnr {:force true})))

    ;; Return back from insert mode
    (vim.api.nvim_command :stopinsert))

  ;; Create requested views
  (local total-views (if config.views (length config.views) 0))
  (local has-views (> total-views 0))
  (local views [])
  (when has-views
    (each [index producer (ipairs config.views)]
      (local view {:view (create-view {: layout : index : total-views}) : producer})
      (table.insert views view)
      (table.insert buffers view.view.bufnr)))

  ;; Creates the results buffer and window and stores thier numbers
  (local results-view (create-results-view {: layout : has-views}))

  ;; Register buffer for exiting
  (table.insert buffers results-view.bufnr)

  ;; Helper function for adding selected highlighting
  (fn add-selected-highlight [row]
    (vim.api.nvim_buf_add_highlight results-view.bufnr namespace :Comment (- row 1) 0 -1))

  ;; Helper function for adding positions highlights
  (fn add-positions-highlight [row positions]
    (local line (- row 1))
    (each [_ col (ipairs positions)]
      (vim.api.nvim_buf_add_highlight results-view.bufnr namespace :Search line (- col 1) col)))

  ;; Helper to set lines to results view
  (fn set-lines [start end lines]
    (vim.api.nvim_buf_set_lines results-view.bufnr start end false lines))

  ;; Helper function for getting the line under the cursor
  (fn get-selection [] (tostring (. last-results cursor-row)))

  ;; Creates a producer request
  (fn create-request [config]
    ;; Config validation
    (assert (= (type config.body) :table) "body must be a table")
    (assert (= (type config.cancel) :function) "cancel must be a function")
    ;; Set up the request
    (local request {:is-canceled false})
    ;; Copy each value
    (each [key value (pairs config.body)]
      (tset request key value))
    ;; Cancels the request
    (fn request.cancel [] (tset request :is-canceled true))
    ;; Checkes if request is canceled
    (fn request.canceled [] (or exit request.is-canceled (config.cancel request)))
    request)

  ;; Only write what results are needed
  (fn write-results [results]
    (when (not exit)
      (let [result-size (length results)]
        (if (= result-size 0)
          ;; If there are no results then clear
          (set-lines 0 -1 [])
          ;; Otherwise render partial results
          ;; Don't render more than we need to
          ;; this is getting only the height plus the cursor
          (let [max (+ results-view.height cursor-row)
                partial-results []]
            (each [_ result (ipairs results)
                   :until (= max (length partial-results))]
              (table.insert partial-results (tostring result)))
            ;; Set the lines, but make sure tables are converted to strings
            (set-lines 0 -1 partial-results)
            ;; Update highlights
            (each [row _ (pairs partial-results)]
              (local result (. results row))
              ;; Add positions highlighting
              (when
                (has_meta result :positions)
                (add-positions-highlight row result.positions))
              ;; Add selected highlighting
              (when
                (. selected (tostring result))
                (add-selected-highlight row))))))

      ;; When we are running views schedule them
      (local selection (get-selection))
      (when (and has-views (not= last-requested-selection selection))
        (set last-requested-selection selection)
        (vim.schedule (fn []
          (each [_ {:view { : bufnr : winnr} : producer} (ipairs views)]
            (local request
              (create-request
                {:body {: selection : bufnr : winnr}
                 :cancel (fn [request] (not= request.selection (get-selection)))}))
            (schedule-producer {: producer : request})))))))

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

    ;; Prepare the request
    (local request (create-request {:body {: filter :height results-view.height}
                                    :cancel (fn [request] (not= request.filter last-requested-filter))}))

    ;; Prepare the scheduler config
    (local config {:producer config.producer : request})

    ;; Schedules a write, this can be partial results
    (fn schedule-results-write [results]
      ;; Update that we have rendered
      (set has-rendered true)
      (vim.schedule (partial write-results results)))

    (fn render-loading-screen []
      (set loading-count (+ loading-count 1))
      (vim.schedule (fn []
        (when (not (request.canceled))
          (local loading (create-loading-screen results-view.width results-view.height loading-count))
          (set-lines 0 -1 loading)))))

    ;; Add on end handler
    (fn config.on-end []
      ;; When we have scores attached then sort
      (when
        (has_meta (tbl-first results) :score)
        (partial-quicksort
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
      (accumulate results value)
      ;; This is an optimization to begin writing unscored results
      ;; as early as we can
      (when (and
              (= (length last-results) 0)
              (>= (length results) results-view.height)
              (not (has_meta (tbl-first results) :score)))
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
        (render-loading-screen))
      ;; Render a basic loading screen based on time
      (when
        (and
          (not has-rendered)
          (> (- current-time last-time) 500))
        (set last-time current-time)
        (render-loading-screen)))

    ;; And off we go!
    (schedule-producer config))

  ;; Handles entering
  (fn on-enter []
    (local selected-values (vim.tbl_keys selected))
    (if (= (length selected-values) 0)
      (let [selection (get-selection)]
        (when (not= selection "")
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
        (when (not= selection "")
          (if (. selected selection)
            (tset selected selection nil)
            (tset selected selection true))))))

  ;; On key helper
  (fn on-key-direction [get-next-index]
    (let [line-count (vim.api.nvim_buf_line_count results-view.bufnr)
          index (math.max 1 (math.min line-count (get-next-index cursor-row)))]
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

  ;; Initializes the input view
  (local input-view-info (create-input-view
    {: initial_filter
     : has-views
     : layout
     : prompt
     : on-enter
     : on-exit
     : on-up
     : on-down
     : on-pageup
     : on-pagedown
     : on-select-toggle
     : on-select-all-toggle
     : on-update}))

  ;; Register buffer for exiting
  (table.insert buffers input-view-info.bufnr))

