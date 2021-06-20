(module snap.view.input {require {size snap.view.size
                                  tbl snap.common.tbl
                                  buffer snap.common.buffer
                                  window snap.common.window
                                  register snap.common.register}})

(fn layout [config]
  "Creates the input layout"
  (let [{: width : height : row : col} (config.layout)]
    {:width (if (config.has-views) (math.floor (* width size.view-width)) width)
     :height 1
     :row (- (+ row height) size.padding)
     : col
     :focusable true}))

(local mappings {
  :next [:<C-q>]
  :enter [:<CR>]
  :enter-split [:<C-x>]
  :enter-vsplit [:<C-v>]
  :enter-tab [:<C-t>]
  :exit [:<Esc> :<C-c>]
  :select [:<Tab>]
  :unselect [:<S-Tab>]
  :select-all [:<C-a>]
  :prev-item [:<C-p>]
  :next-item [:<C-n>]
  :prev-page [:<C-b>]
  :next-page [:<C-f>]
  :view-page-down [:<C-d>]
  :view-page-up [:<C-u>]
  :view-toggle-hide [:<C-h>]
})

(defn create [config]
  "Creates the input view"
  (let [bufnr (buffer.create)
        layout-config (layout config)
        winnr (window.create bufnr layout-config)]
    (vim.api.nvim_buf_set_option bufnr :buftype :prompt)
    (vim.fn.prompt_setprompt bufnr config.prompt)
    (buffer.add-highlight bufnr :SnapPrompt 0 0 (string.len config.prompt))
    (vim.api.nvim_command :startinsert)
    (vim.api.nvim_win_set_option winnr :winhl "Normal:SnapNormal,FloatBorder:SnapBorder")

    (local mappings (if config.mappings (tbl.merge mappings config.mappings) mappings))

    (fn get-filter []
      (let [contents (tbl.first (vim.api.nvim_buf_get_lines bufnr 0 1 false))]
        (if contents (contents:sub (+ (length config.prompt) 1)) "")))

    ;; Track exit
    (var exited false)

    (fn on-exit []
      (when (not exited)
        (set exited true)
        (config.on-exit)))

    (fn on-enter [type]
      (config.on-enter type)
      (config.on-exit))

    (fn on-next []
      (config.on-next)
      (config.on-exit))

    (fn on-tab []
      (config.on-select-toggle)
      (config.on-next-item))

    (fn on-shifttab []
      (config.on-select-toggle)
      (config.on-prev-item))

    (fn on-ctrla []
      (config.on-select-all-toggle))

    (fn on_lines []
      (config.on-update (get-filter)))

    (fn on_detach []
      (register.clean bufnr))

    ;; Enter and exit
    ;; e.g. we want to support opening in splits etc
    (register.buf-map bufnr [:n :i] mappings.next on-next)
    (register.buf-map bufnr [:n :i] mappings.enter on-enter)
    (register.buf-map bufnr [:n :i] mappings.enter-split (partial on-enter "split"))
    (register.buf-map bufnr [:n :i] mappings.enter-vsplit (partial on-enter "vsplit"))
    (register.buf-map bufnr [:n :i] mappings.enter-tab (partial on-enter "tab"))
    (register.buf-map bufnr [:n :i] mappings.exit on-exit)

    ;; Selection
    (register.buf-map bufnr [:n :i] mappings.select on-tab)
    (register.buf-map bufnr [:n :i] mappings.unselect on-shifttab)
    (register.buf-map bufnr [:n :i] mappings.select-all on-ctrla)

    ;; Up & down are reversed when view is revered
    (register.buf-map bufnr [:n :i] (if config.reverse [:<Down> :<C-j>] [:<Up> :<C-k>]) config.on-prev-item)
    (register.buf-map bufnr [:n :i] (if config.reverse [:<Up> :<C-k>]  [:<Down> :<C-j>]) config.on-next-item)
    (register.buf-map bufnr [:n :i] mappings.prev-item config.on-prev-item)
    (register.buf-map bufnr [:n :i] mappings.next-item config.on-next-item)

    ;; Up & down are reversed when view is revered
    (register.buf-map bufnr [:n :i] (if config.reverse [:<PageDown>] [:<PageUp>]) config.on-prev-page)
    (register.buf-map bufnr [:n :i] (if config.reverse [:<PageUp>]  [:<PageDown>]) config.on-next-page)
    (register.buf-map bufnr [:n :i] mappings.prev-page config.on-prev-page)
    (register.buf-map bufnr [:n :i] mappings.next-page config.on-next-page)

    ;; Views
    (register.buf-map bufnr [:n :i] mappings.view-page-down config.on-viewpagedown)
    (register.buf-map bufnr [:n :i] mappings.view-page-down config.on-viewpageup)
    (register.buf-map bufnr [:n :i] mappings.view-toggle-hide config.on-view-toggle-hide)

    (vim.api.nvim_command
      (string.format
        "autocmd! BufLeave <buffer=%s> %s"
        bufnr
        (register.get-autocmd-call (tostring bufnr) on-exit)))

    (vim.api.nvim_buf_attach bufnr false {: on_lines : on_detach})

    (fn delete []
      (when (vim.api.nvim_win_is_valid winnr)
        (window.close winnr))
      (when (vim.api.nvim_buf_is_valid bufnr)
        (buffer.delete bufnr {:force true})))

    (fn update [view]
      (let [layout-config (layout config)]
        (window.update winnr layout-config)
        (tset view :height layout-config.height)
        (tset view :width layout-config.width)))

    (local view {: update : delete : bufnr : winnr :width layout-config.width :height layout-config.height})

    (vim.api.nvim_command "augroup SnapInputViewResize")
    (vim.api.nvim_command "autocmd!")
    (vim.api.nvim_command
      (string.format "autocmd VimResized * %s"
        (register.get-autocmd-call :VimResized (fn [] (view:update)))))
    (vim.api.nvim_command "augroup END")

    view))
