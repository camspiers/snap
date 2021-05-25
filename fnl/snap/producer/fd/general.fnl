(module snap.producer.fd.general {require {snap snap
                                           io snap.io}})

(defn create [args request]
  (local cwd (snap.yield vim.fn.getcwd))
  (each [data err kill (io.spawn :fd args cwd)]
    (if request.cancel (do
                         (kill)
                         (coroutine.yield nil))
        (not= err "") (coroutine.yield nil)
        (= data "") (coroutine.yield [])
        (coroutine.yield (vim.split data "\n" true)))))
