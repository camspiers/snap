(let [snap (require :snap)
      io (snap.get :common.io)
      cache (snap.get :consumer.cache)
      tbl (snap.get :common.tbl)]
  (fn [producer]
    (local cached-producer (cache producer))
    (fn [request]
      (var sent false)
      (local files [])
      (each [data (snap.consume cached-producer request)]
        (tbl.accumulate files data)
        (snap.continue))
      (if
        (= request.filter "")
        (coroutine.yield files)
        (do
          (local cwd (snap.sync vim.fn.getcwd))
          (local stdout (vim.loop.new_pipe false))
          (each [data err cancel (io.spawn :fzf [:-f request.filter] cwd stdout)]
            (when (not sent)
              (stdout:write (table.concat files "\n"))
              (stdout:shutdown)
              (set sent true))
            (if
              (request.canceled)
              (do (cancel) (coroutine.yield nil))
              (not= err "")
              (coroutine.yield nil)
              (= data "")
              (snap.continue)
              (coroutine.yield (vim.split data "\n" true))))
          nil)))))
