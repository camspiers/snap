(let [snap (require :snap)
      io (require :snap.common.io)]
  (fn [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
      (each [data err cancel (io.spawn :tmux [:list-sessions "-F" "#S"] cwd)]
        (if
          (request.canceled) (do (cancel) (coroutine.yield nil))
          (not= err "") (coroutine.yield nil)
          (= data "") (coroutine.yield [])
          (coroutine.yield (vim.split (data:sub 1 -2) "\n" true)))))))
