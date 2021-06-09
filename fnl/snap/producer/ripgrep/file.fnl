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
  (fn file.args [new-args]
    (fn [request]
      (let [cwd (snap.sync vim.fn.getcwd)]
        (general request {:args (tbl.concat args new-args) : cwd}))))
  file)
