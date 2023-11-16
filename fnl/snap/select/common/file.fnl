(fn [get-data]
  (fn [selection winnr type]
    (var winnr winnr)
    (let [{: path : lnum : col} (get-data selection)]
      (local path (vim.fn.fnamemodify path ":p"))
      (let [buffer (vim.fn.bufnr path true)]
        (vim.api.nvim_buf_set_option buffer :buflisted true)
        (match type
          nil (when (not= winnr false)
            (vim.api.nvim_win_set_buf winnr buffer))
          :vsplit (do
            (vim.api.nvim_command "vsplit")
            (vim.api.nvim_win_set_buf 0 buffer)
            (set winnr (vim.api.nvim_get_current_win)))
          :split (do
            (vim.api.nvim_command "split")
            (vim.api.nvim_win_set_buf 0 buffer)
            (set winnr (vim.api.nvim_get_current_win)))
          :tab (do
            (vim.api.nvim_command "tabnew")
            (vim.api.nvim_win_set_buf 0 buffer)
            (set winnr (vim.api.nvim_get_current_win))))
        (when (not= lnum nil)
          (vim.api.nvim_win_set_cursor winnr [lnum (if (= col nil) 0 col)]))))))
