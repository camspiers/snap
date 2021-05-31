(module snap.select.currentbuffer)

(defn select [result winnr]
  (let [buffer (vim.fn.bufnr result.filename true)]
    (vim.api.nvim_buf_set_option buffer :buflisted true)
    (vim.api.nvim_win_set_buf winnr buffer)
    (vim.api.nvim_win_set_cursor winnr [result.row 0])))
