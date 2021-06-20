(let [snap (require :snap)
      io (require :snap.common.io)]
  (fn [request {: args : cwd : absolute}]
    (each [data err cancel (io.spawn :rg args cwd)]
      (if
        (request.canceled)
        (do (cancel) (coroutine.yield nil))
        (not= err "")
        (coroutine.yield nil)
        (= data "")
        (snap.continue)
        (do
          (var results (vim.split (data:sub 1 -2) "\n" true))
          (when absolute
            (set results (vim.tbl_map #(string.format "%s/%s" cwd $1) results)))
          (coroutine.yield results))))))
