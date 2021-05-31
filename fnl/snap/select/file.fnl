(module snap.select.file)

(defn select [selection winnr]
  (let [buffer (vim.fn.bufnr (tostring selection) true)]
    (vim.api.nvim_buf_set_option buffer :buflisted true)
    (when (not= winnr false)
      (vim.api.nvim_win_set_buf winnr buffer))))

(defn multiselect [selections winnr]
  (each [index selection (ipairs selections)]
    (select selection (if (= (length selections) index) winnr false))))
