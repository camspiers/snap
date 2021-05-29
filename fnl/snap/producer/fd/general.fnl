(let [io (require :snap.io)]
  (fn [args cwd request]
    (each [data err kill (io.spawn :fd args cwd)]
      (if (request.canceled) (do
                           (kill)
                           (coroutine.yield nil))
          (not= err "") (coroutine.yield nil)
          (= data "") (coroutine.yield [])
          (coroutine.yield (vim.split data "\n" true))))))
