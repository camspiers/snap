(let [snap (require :snap)
      read-file (snap.get :preview.read-file)
      loading (snap.get :loading)]
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
        (local fake-path (.. (vim.fn.tempname) "/" (vim.fn.fnamemodify (tostring request.selection) ":t")))
        (vim.api.nvim_buf_set_name request.bufnr fake-path)
        ;; Detect filetype
        (vim.api.nvim_buf_call request.bufnr (fn []
          ;; Use the fake path to enable ftdetection
          (vim.api.nvim_command "filetype detect")))
        (set preview nil))))

    ;; Free memory
    (set preview nil)))
