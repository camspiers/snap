(module snap.select.vimgrep)

(fn parse [line]
  (let [parts (vim.split line ":")]
    {:filename (. parts 1)
     :lnum (tonumber (. parts 2))
     :col (tonumber (. parts 3))
     :text (. parts 4)}))

(defn multiselect [lines winnr]
  (vim.fn.setqflist (vim.tbl_map parse lines))
  (vim.api.nvim_command :copen)
  (vim.api.nvim_command :cfirst))

(defn select [line winnr]
  (let [{: filename : lnum : col} (parse line)]
    (let [buffer (vim.fn.bufnr filename true)]
      (vim.api.nvim_buf_set_option buffer :buflisted true)
      (vim.api.nvim_win_set_buf winnr buffer)
      (vim.api.nvim_win_set_cursor winnr [lnum col]))))
