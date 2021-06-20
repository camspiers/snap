(module snap.view.results {require {size snap.view.size
                                    buffer snap.common.buffer
                                    window snap.common.window}})

(fn layout [config]
  "Creates the results layout"
  (let [{: width : height : row : col} (config.layout)]
    {:width (if config.has-views (math.floor (* width size.view-width)) width)
     :height (- height size.border size.border size.padding)
     : row
     : col
     :focusable false}))

(defn create [config]
  "Creates the results view"
  (let [bufnr (buffer.create)
        layout (layout config)
        winnr (window.create bufnr layout)]
    (vim.api.nvim_buf_set_option bufnr :buftype :prompt)
    (vim.api.nvim_buf_set_option bufnr :textwidth 0)
    (vim.api.nvim_buf_set_option bufnr :wrapmargin 0)
    (vim.api.nvim_win_set_option winnr :wrap false)
    (vim.api.nvim_win_set_option winnr :cursorline true)
    (vim.api.nvim_win_set_option winnr :winhl "CursorLine:SnapSelect,Normal:SnapNormal,FloatBorder:SnapBorder")
    {: bufnr : winnr :height layout.height :width layout.width}))
