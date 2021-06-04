(let [snap (require :snap)
      parse (snap.get :common.vimgrep.parse)]
  (fn [request]
    ;; Write the preview to the buffer.
    (snap.sync (fn []
      (when (not (request.canceled))
        ;; Highlight using the cursor
        (vim.api.nvim_win_set_option request.winnr :cursorline true)
        (vim.api.nvim_win_set_option request.winnr :cursorcolumn true)
        (vim.api.nvim_win_set_buf request.winnr request.selection.bufnr)
        (local total-lines (length (vim.api.nvim_buf_get_lines request.selection.bufnr 0 -1 false)))
        (vim.api.nvim_win_set_cursor request.winnr [(math.min request.selection.lnum total-lines) 0]))))))
    
