(module snap.file {require {snap snap utils snap.utils}})

(fn get_results [message]
  (utils.run "rg --files --no-ignore --hidden"))

(fn on_select [file winnr]
  (let [buffer (vim.fn.bufnr file true)]
    (vim.api.nvim_buf_set_option buffer :buflisted true)
    (when (not= winnr false)
      (vim.api.nvim_win_set_buf winnr buffer))))

(fn on_multiselect [files winnr]
  (each [index file (ipairs files)]
    (on_select file (if (= (length files) index) winnr false))))

(defn run [] (snap.run {:prompt :Files
                        :get_results (snap.filter_with_score get_results)
                        : on_select
                        : on_multiselect}))

