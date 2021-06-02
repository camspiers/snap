(let [io (require :snap.io)]
  (fn [request {: args : cwd}]
    (each [data err cancel (io.spawn :rg args cwd)]
      (if
        (request.canceled) (do (cancel) (coroutine.yield nil))
        (not= err "") (coroutine.yield nil)
        (= data "") (coroutine.yield [])
        (do
          (local results [])
          (each [line (data:gmatch "([^\r\n]*)[\r\n]?")]
            (table.insert results line))
          (coroutine.yield results))))))
