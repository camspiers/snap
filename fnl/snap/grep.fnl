(module snap.grep {require {snap snap io snap.io}})

(fn get_results [request]
  (local cwd (snap.yield vim.fn.getcwd))
  (each [data err kill (io.spawn :rg [:--vimgrep :--hidden request.filter] cwd)]
    (if request.cancel (do
                         (kill)
                         (coroutine.yield nil))
        (not= err "") (coroutine.yield nil)
        (= data "") (coroutine.yield [])
        (coroutine.yield (vim.split data "\n" true)))))

(fn parse [line]
  (let [parts (vim.split line ":")]
    {:filename (. parts 1)
     :lnum (tonumber (. parts 2))
     :col (tonumber (. parts 3))
     :text (. parts 4)}))

(fn on_multiselect [lines winnr]
  (vim.fn.setqflist (vim.tbl_map parse lines))
  (vim.api.nvim_command :copen)
  (vim.api.nvim_command :cfirst))

(fn on_select [line winnr]
  (let [{: filename : lnum : col} (parse line)]
    (let [buffer (vim.fn.bufnr filename true)]
      (vim.api.nvim_buf_set_option buffer :buflisted true)
      (vim.api.nvim_win_set_buf winnr buffer)
      (vim.api.nvim_win_set_cursor winnr [lnum col]))))

(defn run [] (snap.run {:prompt :Grep
                        : get_results
                        : on_select
                        : on_multiselect}))

(defn cursor [] (snap.run {:prompt :Grep
                           :initial-filter (vim.fn.expand :<cword>)
                           : get_results
                           : on_select
                           : on_multiselect}))

