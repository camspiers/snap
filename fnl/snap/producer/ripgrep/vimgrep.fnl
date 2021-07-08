(let [snap (require :snap)
      tbl (snap.get :common.tbl)
      general (snap.get :producer.ripgrep.general)]
  (local vimgrep {})
  (local args [:--line-buffered :-M 100 :--vimgrep])
  (local line-args [:--line-buffered :-M 100 :--no-heading :--column])
  (fn vimgrep.default [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
      (general request {:args (tbl.concat args [request.filter]) : cwd})))
  (fn vimgrep.hidden [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
      (general request {:args (tbl.concat args [:--hidden request.filter]) : cwd})))
  (fn vimgrep.line [new-args cwd]
    (let [args (tbl.concat line-args new-args)
          absolute (not= cwd nil)]
      (fn [request]
        (let [cmd (or cwd (snap.sync vim.fn.getcwd))]
          (general request {:args (tbl.concat args [request.filter]) : cwd : absolute})))))
  (fn vimgrep.args [new-args cwd]
    (let [args (tbl.concat args new-args)
          absolute (not= cwd nil)]
      (fn [request]
        (let [cwd (or cwd (snap.sync vim.fn.getcwd))]
          (general request {:args (tbl.concat args [request.filter]) : cwd : absolute})))))
  vimgrep)
