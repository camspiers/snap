(let [snap (require :snap)
      general (snap.get :producer.ripgrep.general)]
  (local vimgrep {})
  (local args [:--line-buffered :-M 100 :--vimgrep])
  (fn vimgrep.default [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
      (general request {:args [(unpack args) request.filter] : cwd})))
  (fn vimgrep.args [new-args cwd]
    (let [args (tbl.concat args new-args)
          absolute (not= cwd nil)]
      (fn [request]
        (let [cwd (or cwd (snap.sync vim.fn.getcwd))]
          (general request {:args [(unpack args) request.filter] : cwd : absolute})))))
  vimgrep)
