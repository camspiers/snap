(let [snap (require :snap)
      tbl (snap.get :common.tbl)
      general (snap.get :producer.git.general)]
  (local git {})
  (local args [:ls-files])
  (fn git.default [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
      (general request {:args args : cwd})))
  (fn git.args [new-args]
    (let [args (tbl.concat args new-args)]
      (fn [request]
        (let [cwd (or cwd (snap.sync vim.fn.getcwd))]
          (general request {: args : cwd})))))
  git)
