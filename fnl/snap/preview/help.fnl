(let [snap (require :snap)
      read-file (snap.get :preview.read-file)
      loading (snap.get :loading)
      syntax (snap.get :preview.syntax)]
  (fn [request]
    ;; Write the preview to the buffer.
    (snap.sync (fn []
      (when (not (request.canceled))
        (vim.api.nvim_buf_set_option request.bufnr :buftype :help)
        (vim.api.nvim_buf_call request.bufnr (fn []
          (vim.api.nvim_command (string.format "noautocmd help %s" (tostring request.selection)))
          (vim.api.nvim_buf_set_option request.bufnr :syntax :help))))))))
