(let [snap (require :snap)
      io (snap.get :common.io)
      cache (snap.get :consumer.cache)
      positions (snap.get :consumer.positions)
      tbl (snap.get :common.tbl)]
  (fn [producer]
    (local cached-producer (cache producer))
    (positions (fn [request]
      (local results [])
      (var results-string nil)
      (each [data (snap.consume cached-producer request)]
        (tbl.accumulate results data)
        (snap.continue))
      (if
        (= request.filter "")
        (coroutine.yield results)
        (do
          (var needsdata true)
          (local cwd (snap.sync vim.fn.getcwd))
          (local stdout (vim.loop.new_pipe false))
          (each [data err cancel (io.spawn :fzf [:-f request.filter] cwd stdout)]
            (when needsdata
              (when (= results-string nil)
                (local plain-results (vim.tbl_map #(tostring $1) results))
                (set results-string (table.concat plain-results "\n")))
              (stdout:write results-string)
              (stdout:shutdown)
              (set needsdata false))
            (if
              (request.canceled)
              (do (cancel) (coroutine.yield nil))
              (not= err "")
              (coroutine.yield nil)
              (= data "")
              (snap.continue)
              (do
                (local results-indexed {})
                (each [_ result (ipairs results)]
                  (tset results-indexed (tostring result) result))
                (local filtered-results (vim.split (data:sub 1 -2) "\n" true))
                (coroutine.yield (vim.tbl_map #(. results-indexed $1) filtered-results)))))
          nil))))))
