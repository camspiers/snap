(let [snap (require :snap)
      io (snap.get :common.io)
      cache (snap.get :consumer.cache)
      positions (snap.get :consumer.positions)
      tbl (snap.get :common.tbl)
      string (snap.get :common.string)]
  (fn [producer]
    (local cached-producer (cache producer))
    (positions (fn [request]
      (local results [])
      (each [data (snap.consume cached-producer request)]
        (tbl.acc results data)
        (snap.continue))
      (local results-string (table.concat (vim.tbl_map #(tostring $1) results) "\n"))
      (if
        (= request.filter "")
        (coroutine.yield results)
        (do
          (local cwd (snap.sync vim.fn.getcwd))
          (local stdout (vim.loop.new_pipe false))
          (local fzf (io.spawn :fzf [:-f request.filter] cwd stdout))

          (stdout:write results-string)
          (stdout:shutdown)

          (each [data err kill fzf]
            (if
              (request.canceled)
              (do
                (kill)
                (coroutine.yield nil))
              (not= err "")
              (coroutine.yield nil)
              (= data "")
              (snap.continue)
              (do
                (local results-indexed {})
                (each [_ result (ipairs results)]
                  (tset results-indexed (tostring result) result))
                (local filtered-results (string.split data))
                (coroutine.yield (vim.tbl_map #(. results-indexed $1) filtered-results)))))
          nil))))))
