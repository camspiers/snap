(module snap.buffer {require {snap snap}})

(fn on_select [selection winnr]
  (let [buffer (vim.fn.bufnr selection true)]
    (vim.api.nvim_buf_set_option buffer :buflisted true)
    (vim.api.nvim_win_set_buf winnr buffer)))

(fn get-slow-data []
  (vim.tbl_map #(vim.fn.bufname $1)
               (vim.tbl_filter #(and (not= (vim.fn.bufname $1) "")
                                     (= (vim.fn.buflisted $1) 1)
                                     (= (vim.fn.bufexists $1) 1))
                               (vim.api.nvim_list_bufs))))

(fn get_results [message]
  (local (_ buffers) (coroutine.yield get-slow-data))
  buffers)

(defn run [] (snap.run {:prompt :Buffers
                        :get_results (snap.filter_with_score get_results)
                        : on_select}))

