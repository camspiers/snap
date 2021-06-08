(let [io (require :snap.common.io)]
  (fn [request {: args : cwd}]
    (each [data err kill (io.spawn :fd args cwd)]
      (if (request.canceled) (do
                           (kill)
                           (coroutine.yield nil))
          (not= err "") (coroutine.yield nil)
          (= data "") (coroutine.yield [])
          (coroutine.yield (vim.split (data:sub 1 -2) "\n" true))))))
