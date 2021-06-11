(let [snap (require :snap)
      io (snap.get :common.io)
      cache (snap.get :consumer.cache)
      positions (snap.get :consumer.positions)
      tbl (snap.get :common.tbl)]
  (fn [producer]
    (local cached-producer (cache producer))
    (positions (fn [request]
      (local files [])
      (var files-string nil)
      (each [data (snap.consume cached-producer request)]
        (tbl.accumulate files data)
        (snap.continue))
      (if
        (= request.filter "")
        (coroutine.yield files)
        (do
          (var needsdata true)
          (local cwd (snap.sync vim.fn.getcwd))
          (local stdout (vim.loop.new_pipe false))
          (each [data err cancel (io.spawn :fzf [:-f request.filter] cwd stdout)]
            (when needsdata
              (when (= files-string nil)
                (local plain-files (vim.tbl_map #(tostring $1) files))
                (set files-string (table.concat plain-files "\n")))
              (stdout:write files-string)
              (stdout:shutdown)
              (set needsdata false))
            (if
              (request.canceled)
              (do (cancel) (coroutine.yield nil))
              (not= err "")
              (coroutine.yield nil)
              (= data "")
              (snap.continue)
              (coroutine.yield (vim.split (data:sub 1 -2) "\n" true))))
          nil))))))
