(let [io (require :snap.common.io)
      string (require :snap.common.string)]
  (fn [request {: args : cwd}]
    (each [data err cancel (io.spawn :git args cwd)]
      (if
        (request.canceled) (do (cancel) (coroutine.yield nil))
        (not= err "") (coroutine.yield nil)
        (= data "") (coroutine.yield [])
        (coroutine.yield (string.split data))))))
