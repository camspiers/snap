(let [snap (require :snap)
      io (require :snap.common.io)]
  (fn [request {: args : cwd}]
    (each [data err cancel (io.spawn :rg args cwd)]
      (if
        (request.canceled)
        (do (cancel) (coroutine.yield nil))
        (not= err "")
        (coroutine.yield nil)
        (= data "")
        (snap.continue)
        (coroutine.yield (vim.split (data:sub 1 -2) "\n" true))))))
