(let [snap (require :snap)
      tbl (snap.get :common.tbl)
      general (snap.get :producer.fd.general)]
  (local directory {})
  (local args [:--no-ignore-vcs :-t :d])
  (fn directory.default [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
      (general request {: args : cwd})))
  (fn directory.hidden [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
      (general request {:args [:--hidden (unpack args)] : cwd})))
  (fn directory.args [new-args]
    (fn [request]
      (let [cwd (snap.sync vim.fn.getcwd)]
        (general request {:args (tbl.concat args new-args) : cwd}))))
  directory)
