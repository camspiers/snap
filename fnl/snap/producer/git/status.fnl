(let [snap (require :snap)
      general (snap.get :producer.git.general)]
  (fn [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
      (general request {:args [:status :--porcelain] : cwd}))))
