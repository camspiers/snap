(let [snap (require :snap)
      loading (snap.get :loading)
      read-file (snap.get :preview.read-file)
      parse (snap.get :common.vimgrep.parse)
      syntax (snap.get :preview.syntax)]
  (fn [request]
    ;; Display loading
    (var load-counter 0)
    (var last-time 0)

    ;; Progressively renders loader
    (fn render-loader []
      ;; Don't always render
      (when
        (> (- (vim.loop.now) last-time) 500)
        (snap.sync (fn []
          (when (not (request.canceled))
              (set last-time (vim.loop.now))
              (set load-counter (+ load-counter 1))
              (vim.api.nvim_buf_set_lines
                request.bufnr
                0
                -1
                false 
                (loading request.width request.height load-counter)))))))

    (local selection (parse (tostring request.selection)))
    (local path (snap.sync (partial vim.fn.fnamemodify selection.filename ":p")))
    ;; Get the preview
    (var preview (read-file path render-loader))
    (local preview-size (length preview))
    ;; Write the preview to the buffer.
    (snap.sync (fn []
      (when (not (request.canceled))
        ;; Highlight using the cursor
        (vim.api.nvim_win_set_option request.winnr :cursorline true)
        ;; Set the preview
        (vim.api.nvim_buf_set_lines request.bufnr 0 -1 false preview)
        ;; Try to set cursor to appropriate line
        (when (<= selection.lnum preview-size)
          ;; TODO Col highlighting isn't working
          (vim.api.nvim_win_set_cursor request.winnr [selection.lnum (- selection.col 1)]))
        ;; Add synxtax highlighting
        (syntax (vim.fn.fnamemodify selection.filename ":t") request.bufnr))))
    
    (set preview nil)))
