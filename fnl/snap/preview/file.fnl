(let [snap (require :snap)
      get (snap.get :preview.get)
      loading (snap.get :loading)]
  (fn [request]
    ;; Display loading
    (snap.sync (fn []
      (vim.api.nvim_buf_set_lines
        request.bufnr
        0
        -1
        false 
        (loading request.width request.height 4))))

    (local path (snap.sync (partial vim.fn.fnamemodify (tostring request.selection) ":p")))

    ;; Get the preview
    ;; TODO an optimization here would be to update the loader
    (var preview (get path))

    ;; Write the preview to the buffer.
    (snap.sync (fn []
      (when (not (request.canceled))
        ;; We don't need a cursorline
        (vim.api.nvim_win_set_option request.winnr :cursorline false)
        (vim.api.nvim_win_set_option request.winnr :cursorcolumn false)
        ;; Clear the filename
        (vim.api.nvim_buf_set_name request.bufnr "")
        ;; Clear the filetype
        (vim.api.nvim_buf_set_option request.bufnr "filetype" "")
        ;; Set the preview
        (vim.api.nvim_buf_set_lines request.bufnr 0 -1 false preview)
        (set preview nil))))

    ;; Do file type detection
    (snap.sync (fn []
      (when (not (request.canceled))
        ;; In case it's accidently saved
        (local fake-path (.. (vim.fn.tempname) "%" (vim.fn.fnamemodify (tostring request.selection) ":p:gs?/?%?")))
        ;; Use the fake path to enable ftdetection
        (vim.api.nvim_buf_set_name request.bufnr fake-path)
        ;; Detect filetype
        (vim.api.nvim_buf_call request.bufnr (fn []
          (vim.api.nvim_command "filetype detect")))
        ;; For the moment kill ts as it is causing performance problems
        (local highlighter (. vim.treesitter.highlighter.active request.bufnr))
        (when highlighter (highlighter:destroy)))))

    ;; Free memory
    (set preview nil)))
