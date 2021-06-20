(module snap.view.view {require {size snap.view.size
                                 buffer snap.common.buffer
                                 window snap.common.window
                                 tbl snap.common.tbl}})

(fn layout [config]
  "Creates a view layout"
  (let [{: width : height : row : col} (config.layout)
        index (- config.index 1)
        border (* index size.border)
        padding (* index size.padding)
        total-borders (* (- config.total-views 1) size.border)
        total-paddings (* (- config.total-views 1) size.padding)
        sizes (tbl.allocate (- height total-borders total-paddings) config.total-views)
        height (. sizes config.index)
        col-offset (math.floor (* width size.view-width))]
    {:width (- width col-offset)
     : height
     :row (+ row (tbl.sum (tbl.take sizes index)) border padding)
     :col (+ col col-offset (* size.border 2) size.padding)
     :focusable false}))

(defn create [config]
  "Creates a view"
  (let [bufnr (buffer.create)
        layout (layout config)
        winnr (window.create bufnr layout)]
    (vim.api.nvim_win_set_option winnr :cursorline false)
    (vim.api.nvim_win_set_option winnr :wrap false)
    (vim.api.nvim_win_set_option winnr :winhl "Normal:SnapNormal,FloatBorder:SnapBorder")
    {: bufnr : winnr :height layout.height :width layout.width}))
