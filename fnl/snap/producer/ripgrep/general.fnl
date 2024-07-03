(let [snap (require :snap)
           io (snap.get :common.io)
           string (snap.get :common.string)]
  (fn [request {: args : cwd : absolute}]
    (if
      (= request.filter "")
      (coroutine.yield nil)
      (each [data err cancel (io.spawn :rg args cwd)]
        (if
          (request.canceled)
          (do (cancel) (coroutine.yield nil))
          (not= err "")
          (coroutine.yield nil)
          (= data "")
          (snap.continue)
          (do
            (var results (string.split data))

            (when absolute
              (set results (vim.tbl_map #(string.format "%s/%s" cwd $1) results)))
            (coroutine.yield results)))))))
