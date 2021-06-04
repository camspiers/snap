(module snap.select.jumplist)

(defn select [selection winnr]
  (let [{: bufnr : lnum : col} selection]
    (vim.api.nvim_win_set_buf winnr bufnr)
    (vim.api.nvim_win_set_option winnr :relativenumber true)
    (vim.api.nvim_win_set_cursor winnr [lnum col])))
