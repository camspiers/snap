(module snap.select.vimgrep {require {parse snap.common.vimgrep.parse
                                      select-file snap.select.common.file}})

(defn multiselect [selections winnr]
  (vim.fn.setqflist (vim.tbl_map parse selections))
  (vim.api.nvim_command :copen)
  (vim.api.nvim_command :cfirst))

(def select (select-file (fn [selection]
  (let [{: filename : lnum : col} (parse selection)]
    {:path filename : lnum : col}))))
