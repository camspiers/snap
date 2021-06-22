(module snap.select.file)

(defn select [selection winnr type]
  (local path (vim.fn.fnamemodify (tostring selection) ":p"))
  (let [buffer (vim.fn.bufnr path true)]
    (vim.api.nvim_buf_set_option buffer :buflisted true)
    (match type
      nil (when (not= winnr false)
        (vim.api.nvim_win_set_buf winnr buffer))
      :vsplit (do
        (vim.api.nvim_command "vsplit")
        (vim.api.nvim_win_set_buf 0 buffer))
      :split (do
        (vim.api.nvim_command "split")
        (vim.api.nvim_win_set_buf 0 buffer))
      :tab (do
        (vim.api.nvim_command "tabnew")
        (vim.api.nvim_win_set_buf 0 buffer)))))


(defn multiselect [selections winnr]
  (each [index selection (ipairs selections)]
    (select selection (if (= (length selections) index) winnr false))))
