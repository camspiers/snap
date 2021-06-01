(let [snap (require :snap)
      get (snap.get :preview.get)
      parse (snap.get :common.vimgrep.parse)]

  (fn [request]
    (local selection (parse (tostring request.selection)))
    (local path (snap.sync (partial vim.fn.fnamemodify selection.filename ":p")))
    ;; Get the preview
    (var preview (get path))
    (local preview-size (length preview))
    ;; Write the preview to the buffer.
    (snap.sync (fn []
      (when (not (request.canceled))
        ;; Highlight using the cursor
        (vim.api.nvim_win_set_option request.winnr :cursorline true)
        (vim.api.nvim_win_set_option request.winnr :cursorcolumn true)
        ;; Clear the filetype
        (vim.api.nvim_buf_set_option request.bufnr "filetype" "")
        ;; Set the preview
        (vim.api.nvim_buf_set_lines request.bufnr 0 -1 false preview)
        (set preview nil))))
    ;; Do file type detection
    (snap.sync (fn []
      (when (not (request.canceled))
        ;; In case it's accidently saved
        (local fake-path (.. (vim.fn.tempname) "%" (vim.fn.fnamemodify selection.filename ":p:gs?/?%?")))
        ;; Use the fake path to enable ftdetection
        (vim.api.nvim_buf_set_name request.bufnr fake-path)
        ;; Detect the file type
        (vim.api.nvim_buf_call request.bufnr (fn []
          (vim.api.nvim_command "filetype detect")))
        ;; For the moment kill ts as it is causing performance problems
        (local highlighter (. vim.treesitter.highlighter.active request.bufnr))
        (when highlighter (highlighter:destroy))
        ;; Try to set cursor to appropriate line
        (when (<= selection.lnum preview-size)
          ;; TODO Col highlighting isn't working
          (vim.api.nvim_win_set_cursor request.winnr [selection.lnum (- selection.col 1)])))))
    
    (set preview nil)))
