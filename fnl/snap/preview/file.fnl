(let [snap (require :snap)
      read-file (snap.get :preview.read-file)
      loading (snap.get :loading)
      syntax (snap.get :preview.syntax)]
  (fn [request]
    ;; Display loading
    (var load-counter 0)
    (var last-time (vim.loop.now))

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

    ;; Compute the path
    (local path (snap.sync (partial vim.fn.fnamemodify (tostring request.selection) ":p")))

    ;; Get the preview
    (var preview (read-file path render-loader))

    ;; Write the preview to the buffer.
    (snap.sync (fn []
      (when (not (request.canceled))
        ;; We don't need a cursorline
        (vim.api.nvim_win_set_option request.winnr :cursorline false)
        (vim.api.nvim_win_set_option request.winnr :cursorcolumn false)
        ;; Set the preview
        (vim.api.nvim_buf_set_lines request.bufnr 0 -1 false preview)
        ;; Add syntax highlighting
        (syntax (vim.fn.fnamemodify (tostring request.selection) ":t") request.bufnr))))
    ;; Free memory
    (set preview nil)))
