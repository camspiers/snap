(module snap.view.results {require {size snap.view.size
                                    buffer snap.common.buffer
                                    window snap.common.window
                                    register snap.common.register}})

(fn layout [config]
  "Creates the results layout"
  (let [{: width : height : row : col} (config.layout)]
    {:width (if (config.has-views) (math.floor (* width size.view-width)) width)
     :height (- height size.border size.border size.padding)
     : row
     : col
     :focusable false}))

(defn create [config]
  "Creates the results view"
  (let [bufnr (buffer.create)
        layout-config (layout config)
        winnr (window.create bufnr layout-config)]

    (vim.api.nvim_buf_set_option bufnr :buftype :prompt)
    (vim.api.nvim_buf_set_option bufnr :textwidth 0)
    (vim.api.nvim_buf_set_option bufnr :wrapmargin 0)
    (vim.api.nvim_win_set_option winnr :wrap false)
    (vim.api.nvim_win_set_option winnr :cursorline true)
    (vim.api.nvim_win_set_option winnr :winhl "CursorLine:SnapSelect,Normal:SnapNormal,FloatBorder:SnapBorder")

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

    (vim.api.nvim_command "augroup SnapResultsViewResize")
    (vim.api.nvim_command "autocmd!")
    (vim.api.nvim_command
      (string.format "autocmd VimResized * %s"
        (register.get-autocmd-call :VimResized (fn [] (view:update)))))
    (vim.api.nvim_command "augroup END")

    view))

