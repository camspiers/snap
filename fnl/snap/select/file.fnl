(module snap.select.file)

(defn select [file winnr]
  (let [buffer (vim.fn.bufnr file true)]
    (vim.api.nvim_buf_set_option buffer :buflisted true)
    (when (not= winnr false)
      (vim.api.nvim_win_set_buf winnr buffer))))

(defn multiselect [files winnr]
  (each [index file (ipairs files)]
    (select file (if (= (length files) index) winnr false))))
