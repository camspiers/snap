(module snap.select.vimgrep)

(local parse (require :snap.common.vimgrep.parse))

(defn multiselect [selections winnr]
  (vim.fn.setqflist (vim.tbl_map parse selections))
  (vim.api.nvim_command :copen)
  (vim.api.nvim_command :cfirst))

(defn select [selection winnr]
  (let [{: filename : lnum : col} (parse selection)]
    (let [buffer (vim.fn.bufnr filename true)]
      (vim.api.nvim_buf_set_option buffer :buflisted true)
      (vim.api.nvim_win_set_buf winnr buffer)
      (vim.api.nvim_win_set_cursor winnr [lnum col]))))
