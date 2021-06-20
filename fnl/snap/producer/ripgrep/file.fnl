(let [snap (require :snap)
      tbl (snap.get :common.tbl)
      general (snap.get :producer.ripgrep.general)]
  (local file {})
  (local args [:--line-buffered :--files])
  (fn file.default [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
      (general request {: args : cwd})))
  (fn file.hidden [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
      (general request {:args [:--hidden (unpack args)] : cwd})))
  (fn file.args [new-args cwd]
    (let [args (tbl.concat args new-args)
          absolute (not= cwd nil)]
      (fn [request]
        (let [cwd (or cwd (snap.sync vim.fn.getcwd))]
          (general request {: args : cwd : absolute})))))
  file)
