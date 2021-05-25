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
;; Requirements:                                                              ;;
;;                                                                            ;;
;;   - aniseed                                                                ;;
;;   - fzy (via luarocks, or just path accessible via 'fzy')                  ;;
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

(module snap {require {fzy fzy}})

;; Basic helper to get the first value
(fn tbl-first [tbl]
  (when tbl
    (. tbl 1)))

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

;; Global accessible layouts
;; Currently layouts always have the input placed below and therefore room
;; must be left available for it to fit
(def layouts {})

;; Helper to get lines
(fn layouts.lines []
  (vim.api.nvim_get_option :lines))

;; Helper to get columns
(fn layouts.columns []
  (vim.api.nvim_get_option :columns))

;; The middle for the height or width requested (from top or left)
(fn layouts.middle [total size]
  (math.floor (/ (- total size) 2)))

(fn layouts.from-bottom [size offset]
  (- (layouts.lines) size offset))

(fn layouts.size [%width %height]
  {:width (math.floor (* (layouts.columns) %width))
   :height (math.floor (* (layouts.lines) %height))})

(fn layouts.%centered [%width %height]
  (let [{: width : height} (layouts.size %width %height)]
    {: width
     : height
     :row (layouts.middle (layouts.lines) height)
     :col (layouts.middle (layouts.columns) width)}))

(fn layouts.%bottom [%width %height]
  (let [{: width : height} (layouts.size %width %height)]
    {: width
     : height
     :row (layouts.from-bottom height 8)
     :col (layouts.middle (layouts.columns) width)}))

(fn layouts.%top [%width %height]
  (let [{: width : height} (layouts.size %width %height)]
    {: width : height :row 5 :col (layouts.middle (layouts.columns) width)}))

;; Primary available layouts: centered, bottom, top

(fn layouts.centered []
  (layouts.%centered 0.8 0.5))

(fn layouts.bottom []
  (layouts.%bottom 0.8 0.5))

(fn layouts.top []
  (layouts.%top 0.8 0.5))

;; Stores mappings for buffers
(def fns {})

;; Cleans up unneeded buffer maps
(fn fns.clean [bufnr]
  (tset fns bufnr nil))

;; Provides ability to run fn
(fn fns.run [bufnr fnc]
  (when (?. fns bufnr fnc)
    ((. fns bufnr fnc))))

(fn fns.get-by-template [bufnr fnc pre post]
  (let [buf-fns (or (. fns bufnr) [])
        id (string.format "%s" fnc)]
    (tset fns bufnr buf-fns)
    (when (= (. buf-fns id) nil)
      (tset buf-fns id fnc))
    (string.format "%slua require'snap'.fns.run(%s, '%s')%s" pre bufnr id post)))

;; Generates call signiture for maps
(fn fns.get-map-call [bufnr fnc]
  (fns.get-by-template bufnr fnc :<Cmd> :<CR>))

;; Generates call signiture for autocmds
(fn fns.get-autocmd-call [bufnr fnc]
  (fns.get-by-template bufnr fnc ":" ""))

;; Creates a buffer mapping and creates callable signiture
(fn fns.map [bufnr keys fnc]
  (let [rhs (fns.get-map-call bufnr fnc)]
    (each [_ key (ipairs keys)]
      (vim.api.nvim_buf_set_keymap bufnr :n key rhs {})
      (vim.api.nvim_buf_set_keymap bufnr :i key rhs {}))))

;; Modifies the basic window options to make the input sit below
(fn create-input-layout [layout]
  (let [{: width : height : row : col} (layout)]
    {: width :height 1 :row (+ height row 2) : col :focusable true}))

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
        layout (config.layout)
        winnr (create-window bufnr layout)]
    (vim.api.nvim_win_set_option winnr :cursorline true)
    (vim.api.nvim_win_set_option winnr :wrap false)
    (vim.api.nvim_buf_set_option bufnr :buftype :prompt)
    {: bufnr : winnr :height layout.height :width layout.width}))

;; Creates the input buffer

;; fnlfmt: skip
(fn create-input-view [config]
  (let [bufnr (create-buffer)
        winnr (create-window bufnr (create-input-layout config.layout))]
    (vim.api.nvim_buf_set_option bufnr :buftype :prompt)
    (vim.fn.prompt_setprompt bufnr config.prompt)
    (vim.api.nvim_command :startinsert)

    (when (~= config.initial-filter "")
      ;; We do it this way because prompts are broken in nvim
      (vim.api.nvim_feedkeys config.initial-filter :n false))

    (fn get-filter []
      (let [contents (tbl-first (vim.api.nvim_buf_get_lines bufnr 0 1 false))]
        (if contents (contents:sub (+ (length config.prompt) 1)) "")))

    (fn on-exit []
      (fns.clean bufnr)
      (config.on-exit))

    (fn on-enter []
      (config.on-enter)
      (on-exit))

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
      (fns.clean bufnr))

    (fns.map bufnr [:<CR>] on-enter)
    (fns.map bufnr [:<Up> :<C-k> :<C-p>] config.on-up)
    (fns.map bufnr [:<Down> :<C-j> :<C-n>] config.on-down)
    (fns.map bufnr [:<Esc> :<C-c>] on-exit)
    (fns.map bufnr [:<Tab>] on-tab)
    (fns.map bufnr [:<S-Tab>] on-shifttab)
    (fns.map bufnr [:<C-a>] on-ctrla)
    (fns.map bufnr [:<C-d>] config.on-pagedown)
    (fns.map bufnr [:<C-u>] config.on-pageup)

    (vim.api.nvim_command
      (string.format "autocmd! WinLeave <buffer=%s> %s" bufnr (fns.get-autocmd-call bufnr on-exit)))

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

;; Accumulates non empty results

;; fnlfmt: skip
(defn accumulate [results partial-results]
  (when (not= partial-results nil)
    (each [_ value (ipairs partial-results)]
      (when (not= (tostring value) "")
        (table.insert results value)))))

;; fnlfmt: skip
(defn yield [value]
  "Basic wrapper around coroutine.yield that returns first result"
  (let [(_ result) (coroutine.yield value)]
    result))

;; fnlfmt: skip
(defn resume [thread request value]
  "Transfers sync values allowing the yielding of functions with non fast-api access"
  (let [(_ result) (coroutine.resume thread request value)]
    (if
      ;; If we are cancelling then return nil
      request.cancel nil
      ;; When we have a function, we want to yield it
      ;; get the value then continue
      (= (type result) :function) (resume thread request (yield result))
      ;; If we aren't canceling then return result
      result)))

;; fnlfmt: skip
(defn consume [producer request]
  "Returns an iterator that consumes a producer"
  (let [reader (coroutine.create producer)]
    (fn []
      (when (not= (coroutine.status reader) :dead)
        (values (resume reader request))))))

;; Run docs:
;;
;; @config: {
;;   "Get the results to display"
;;   :producer () => itable<string>
;;
;;   "Called when value is selected"
;;   :select () => nil
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
;;   :?multiselect (selections) => nil
;; }

;; fnlfmt: skip
(defn run [config]
  ;; Store last search
  (var last-filter nil)

  ;; Store the last results
  (var last-results [])

  ;; Exit flag tracks whether buffers have detatched
  ;; Used to send cancel request to producer coroutines
  (var exit false)

  ;; Store buffers for exiting
  (local buffers [])

  ;; Default to the bottom layout
  (local layout (or config.layout layouts.bottom))

  ;; Store the initial filter
  (local initial-filter (or config.initial-filter ""))

  ;; Creates a namespace for highlighting
  (local namespace (vim.api.nvim_create_namespace :Snap))

  ;; Stores the original window to so we can pass it back to the select function
  (local original-winnr (vim.api.nvim_get_current_win))

  ;; Configures a default or custom prompt
  (local prompt (string.format "%s> " (or config.prompt :Find)))

  ;; Stores the selected items, used for multiselect
  (local selected {})

  ;; Handles exiting
  (fn on-exit []
    ;; Send the signal to exit to all potentially running processes in coroutines
    (set exit true)

    ;; Delete each open buffer
    (each [_ bufnr (ipairs buffers)]
      (when (vim.api.nvim_buf_is_valid bufnr)
        (vim.api.nvim_buf_delete bufnr {:force true})))

    ;; Return back to original window
    (vim.api.nvim_set_current_win original-winnr)

    ;; Return back from insert mode
    (vim.api.nvim_command :stopinsert))

  ;; Creates the results buffer and window and stores thier numbers
  (local view (create-results-view {: layout : on-exit}))

  ;; Register buffer for exiting
  (table.insert buffers view.bufnr)

  ;; Helper function for highlighting
  (fn add-results-highlight [row]
    (vim.api.nvim_buf_add_highlight view.bufnr namespace :Comment (- row 1) 0 -1))

  ;; Helper to set lines to results view
  (fn set-lines [start end lines]
    (vim.api.nvim_buf_set_lines view.bufnr start end false lines))

  ;; Helper function for getting the cursor position
  (fn get-cursor-row [] (let [[row _] (vim.api.nvim_win_get_cursor view.winnr)] row))

  ;; Helper function for getting the line under the cursor
  (fn get-cursor-line [row]
    (tbl-first (vim.api.nvim_buf_get_lines view.bufnr (- row 1) row false)))

  ;; Only write what results are needed
  (fn write-results [results]
    (when (not exit)
      (let [result-size (length results)]
        (if (= result-size 0)
          ;; If there are no results then clear
          (set-lines 0 -1 [])
          ;; Otherwise render partial results
          (do
            ;; Don't render more than we need to
            ;; this is getting only the height plus the cursor
            (local partial-results [(unpack results 1 (+ view.height (get-cursor-row)))])

            ;; Set the lines, but make sure tables are converted to strings
            (set-lines 0 -1 (vim.tbl_map tostring partial-results))

            ;; Update highlights
            (each [row line (pairs partial-results)]
              (when (. selected (tostring line)) (add-results-highlight row))))))))

  ;; This is the non-scheduled version of on-update
  (fn on-update-unwraped [filter height]
    ;; Helper to determine if we should cancel, sent to coroutine
    ;; where it has the responsibility to kill running processes etc
    (fn should-cancel [] (or exit (not= filter last-filter)))

    ;; Only run when the filter hasn't changed from the unscheduled set
    (when (= filter last-filter)
      (let [check (vim.loop.new_check)
            reader (coroutine.create config.producer)]
        ;; Tracks if any results have rendered
        (var has-rendered false)

        ;; Tracks the requests of slow nvim calls
        (var pending-blocking-value false)

        ;; Stores the results of slow nvim calls
        (var blocking-value nil)

        ;; Store the number of times the loading screen has displayed
        (var loading-count 1)

        ;; Store the last time the loap has run
        (var last-time (vim.loop.now))

        ;; Prepare new results array for collection
        (local results [])

        ;; Store the request API for coroutines
        (local request {: filter
                        : height
                        :cancel (should-cancel)})

        ;; Schedules a write, this can be partial results
        (fn schedule-write [results]
          ;; Update that we have rendered
          (set has-rendered true)
          (vim.schedule (partial write-results results)))

        ;; Run this whenever the checker should be considered to have ended
        (fn end []
          ;; Stop the checker
          (check:stop)
          ;; If we aren't resulting cancal then render
          (when (not request.cancel)
            ;; When we have scores attached then sort
            (when
              (has_meta (tbl-first results) :score)
              (partial-quicksort
                results
                1
                (length results)
                view.height
                #(> $1.score $2.score)))
            ;; Store the last written results
            (set last-results results)
            ;; Schedule the write
            (schedule-write results)))

        ;; Schedules a sync value for processing
        (fn schedule-blocking-value [fnc]
          (set pending-blocking-value true) 
          (vim.schedule (fn []
            (set blocking-value (fnc))
            (set pending-blocking-value false))))

        ;; This checker runs on every loop of the event loop
        ;; It checks if the coroutine is not dead and has more values
        (fn checker []
          (when pending-blocking-value
            (lua "return nil"))

          ;; Update the cancel flag
          (tset request :cancel (should-cancel))

          ;; When the coroutine is not dead, process its results
          (if (not= (coroutine.status reader) :dead)
            ;; Fetches results be also sends cancel signal
            (let [(_ value) (coroutine.resume reader request blocking-value)]
              (match (type value)
                ;; We have a function so schedule it to be computed
                "function" (schedule-blocking-value value)
                ;; Store the values, there are more to come
                "table" (do
                  (accumulate results value)
                  ;; This is an optimization to begin writing unscored results
                  ;; as early as we can
                  (when (and
                          (>= (length results) view.height)
                          (not (has_meta (tbl-first results) :score)))
                    (schedule-write results)))
                ;; When there is nil the coroutine has reached its last value
                ;; The coroutine is dead so stop the checker and schedule a write
                "nil" (end)))
            ;; When the coroutine is dead then stop the checker and write
            (end))

          ;; Render a basic loading screen
          (when (and (not has-rendered) (> (- (vim.loop.now) last-time) 500))
            (set last-time (vim.loop.now))
            (set loading-count (+ loading-count 1))
            (vim.schedule (fn []
              (when (not request.cancel)
                (local loading (create-loading-screen view.width view.height loading-count))
                (set-lines 0 -1 loading))))))

        ;; Start the checker after each IO poll
        (check:start checker))))

  ;; You can't immediately start the checker so schedule
  (fn on-update [filter]
    ;; The last filter has changed
    (set last-filter filter)

    ;; Schedule the run
    (vim.schedule (partial on-update-unwraped filter view.height)))

  ;; Handles entering
  (fn on-enter []
    (local selected-values (vim.tbl_values selected))
    (if (= (length selected-values) 0)
      (let [row (get-cursor-row) selection (get-cursor-line row)]
        (when (not= selection "")
          (config.select selection original-winnr)))
      (when config.multiselect (config.multiselect selected-values original-winnr))))

  ;; Handles select all in the multiselect case
  (fn on-select-all-toggle []
    (when config.multiselect
      (each [_ value (ipairs last-results)]
        (if (= (. selected value) nil)
          (tset selected value value)
          (tset selected value nil)))
      (write-results last-results)))

  ;; Handles select in the multiselect case
  (fn on-select-toggle []
    (when config.multiselect
      (let [row (get-cursor-row)
            selection (get-cursor-line row)]
        (when (not= selection "")
          (if (. selected selection)
            (tset selected selection nil)
            (tset selected selection selection))))))

  ;; On key helper
  (fn on-key-direction [get-next-index]
    (let [row (get-cursor-row)
          index (get-next-index row)]
      (vim.api.nvim_win_set_cursor view.winnr
        [(math.max 1 (math.min (vim.api.nvim_buf_line_count view.bufnr) index)) 0])
      (write-results last-results)))

  ;; On up handler
  (fn on-up []
    (on-key-direction #(- $1 1)))

  ;; On down handler
  (fn on-down []
    (on-key-direction #(+ $1 1)))
 
  ;; Page up handler
  (fn on-pageup []
    (on-key-direction #(- $1 view.height)))

  ;; Page down handler
  (fn on-pagedown []
    (on-key-direction #(+ $1 view.height)))

  ;; Initializes the input view
  (local input-view-info (create-input-view
    {: initial-filter
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

