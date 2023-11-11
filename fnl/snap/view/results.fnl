(module snap.view.results {require {size snap.view.size
                                    buffer snap.common.buffer
                                    window snap.common.window
                                    register snap.common.register}})

(local group (vim.api.nvim_create_augroup :SnapResults {:clear true}))

(fn layout [config]
  "Creates the results layout"
  (let [{: width : height : row : col} (config.layout)]
    {:width (if (config.has-views) (- (math.floor (* width size.view-width)) size.padding size.padding) width)
     :height (- height size.border size.border size.padding)
     :row (if config.reverse (+ row size.border size.padding size.padding) row)
     : col
     :focusable false}))

(defn create [config]
  "Creates the results view"
  (let [bufnr (buffer.create)
        layout-config (layout config)
        winnr (window.create bufnr layout-config)]

    (vim.api.nvim_set_option_value :buftype :prompt {:buf bufnr})
    (vim.api.nvim_set_option_value :textwidth 0 {:buf bufnr})
    (vim.api.nvim_set_option_value :wrapmargin 0 {:buf bufnr})
    (vim.api.nvim_set_option_value :wrap false {:win winnr})
    (vim.api.nvim_set_option_value :cursorline true {:win winnr})
    (vim.api.nvim_set_option_value :winhl "CursorLine:SnapSelect,Normal:SnapNormal,FloatBorder:SnapBorder" {:win winnr})

    (fn delete []
      (when (vim.api.nvim_win_is_valid winnr)
        (window.close winnr))
      (when (vim.api.nvim_buf_is_valid bufnr)
        (buffer.delete bufnr)))

    (fn update [view]
      (when (vim.api.nvim_win_is_valid winnr)
        (let [layout-config (layout config)]
          (window.update winnr layout-config)
          (vim.api.nvim_set_option_value :cursorline true {:win winnr})
          (tset view :height layout-config.height)
          (tset view :width layout-config.width))))

    (local view {: update : delete : bufnr : winnr :width layout-config.width :height layout-config.height})

    (vim.api.nvim_create_autocmd
      :VimResized
      { : group :callback (fn [] (view:update)) })

    view))

