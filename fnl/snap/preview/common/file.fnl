(let [snap (require :snap)
      loading (snap.get :loading)
      read-file (snap.get :preview.common.read-file)
      parse (snap.get :common.vimgrep.parse)
      syntax (snap.get :preview.common.syntax)
      tbl (snap.get :common.tbl)]
  (fn [get-file-data]
    (fn [request]
      ;; Display loading
      (var load-counter 0)
      (var last-time (vim.loop.now))
      (local max-length 500)
  
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
  
      (local file-data (get-file-data request.selection))
      (local file-name (vim.fn.fnamemodify file-data.path ":t"))

      ;; Get the preview
      (var preview (read-file file-data.path render-loader))
      (local preview-size (length preview))
      ;; Write the preview to the buffer.
      (snap.sync (fn []
        (when (not (request.canceled))
          ;; Highlight using the cursor
          (vim.api.nvim_win_set_option request.winnr :cursorline true)
          ;; Set the preview
          (vim.api.nvim_buf_set_lines request.bufnr 0 -1 false preview)
          ;; Try to set cursor to appropriate line
          (when (and (not= file-data.line nil) (<= file-data.line preview-size))
            ;; TODO Col highlighting isn't working
            (vim.api.nvim_win_set_cursor request.winnr [file-data.line file-data.column]))
          ;; Add syntax highlighting
          (when
            (< (tbl.max-length preview) max-length)
            (syntax file-name request.bufnr)))))

      (set preview nil))))
