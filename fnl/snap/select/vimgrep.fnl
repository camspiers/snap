(module snap.select.vimgrep)

(local parse (require :snap.common.vimgrep.parse))

(defn multiselect [selections winnr]
  (vim.fn.setqflist (vim.tbl_map parse selections))
  (vim.api.nvim_command :copen)
  (vim.api.nvim_command :cfirst))

(defn select [selection winnr type]
  (var winnr winnr)
  (let [{: filename : lnum : col} (parse selection)]
    (local path (vim.fn.fnamemodify filename ":p"))
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
      (vim.api.nvim_win_set_cursor winnr [lnum col]))))
