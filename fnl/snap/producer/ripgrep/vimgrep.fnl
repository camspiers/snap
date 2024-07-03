(let [snap (require :snap)
      tbl (snap.get :common.tbl)
      general (snap.get :producer.ripgrep.general)]
  (local vimgrep {})
  (local args [:--line-buffered :-M 100 :--vimgrep :-S])
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
  (fn vimgrep.open_files [request]
    (local open_files (snap.sync #(vim.tbl_map #(vim.api.nvim_buf_get_name $1) (vim.api.nvim_list_bufs))))
    (let [cwd (snap.sync vim.fn.getcwd)]
      (general request {:args (tbl.concat args (tbl.concat open_files [request.filter])) : cwd})))
  (fn vimgrep.args [new-args cwd]
    (let [args (tbl.concat args new-args)
          absolute (not= cwd nil)]
      (fn [request]
        (let [cwd (or cwd (snap.sync vim.fn.getcwd))]
          (general request {:args (tbl.concat args [request.filter]) : cwd : absolute})))))
  vimgrep)
