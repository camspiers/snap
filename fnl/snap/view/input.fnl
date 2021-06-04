(module snap.view.input {require {size snap.view.size
                                  tbl snap.common.tbl
                                  buffer snap.common.buffer
                                  window snap.common.window
                                  register snap.common.register}})

(fn layout [config]
  "Creates the input layout"
  (let [{: width : height : row : col} (config.layout)]
    {:width (if config.has-views (math.floor (* width size.view-width)) width)
     :height 1
     :row (- (+ row height) size.padding)
     : col
     :focusable true}))

(defn create [config]
  "Creates the input view"
  (let [bufnr (buffer.create)
        layout (layout config)
        winnr (window.create bufnr layout)]
    (vim.api.nvim_buf_set_option bufnr :buftype :prompt)
    (vim.fn.prompt_setprompt bufnr config.prompt)
    (vim.api.nvim_command :startinsert)

    (fn get-filter []
      (let [contents (tbl.first (vim.api.nvim_buf_get_lines bufnr 0 1 false))]
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

    ;; Enter and exit
    ;; TODO Need to think about other methods of selection
    ;; e.g. we want to support opening in splits etc
    (register.buf-map bufnr [:n :i] [:<CR>] on-enter)
    (register.buf-map bufnr [:n :i] [:<Esc> :<C-c>] on-exit)

    ;; Selection
    (register.buf-map bufnr [:n :i] [:<Tab>] on-tab)
    (register.buf-map bufnr [:n :i] [:<S-Tab>] on-shifttab)
    (register.buf-map bufnr [:n :i] [:<C-a>] on-ctrla)

    ;; Up & down
    (register.buf-map bufnr [:n :i] [:<Up> :<C-p>] config.on-up)
    (register.buf-map bufnr [:n :i] [:<Down> :<C-n>] config.on-down)
    (register.buf-map bufnr [:n :i] [:<C-f> :<PageUp>] config.on-pageup)
    (register.buf-map bufnr [:n :i] [:<C-b> :<PageDown>] config.on-pagedown)

    ;; Views
    (register.buf-map bufnr [:n :i] [:<C-d>] config.on-viewpagedown)
    (register.buf-map bufnr [:n :i] [:<C-u>] config.on-viewpageup)

    (vim.api.nvim_command
      (string.format
        "autocmd! WinLeave <buffer=%s> %s"
        bufnr
        (register.get-autocmd-call (tostring bufnr) on-exit)))

    (vim.api.nvim_buf_attach bufnr false {: on_lines : on_detach})

    {: bufnr : winnr}))
