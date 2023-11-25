(local parse (require :snap.common.vimgrep.parse))
(local file (require :snap.select.common.file))

(fn multiselect [selections winnr]
  (vim.fn.setqflist (vim.tbl_map parse selections))
  (vim.api.nvim_command :copen)
  (vim.api.nvim_command :cfirst))

(local select
  (file (fn [selection]
    (local {: filename :lnum line :col column} (parse selection))
      {: filename : line : column})))

{: select
 : multiselect}
