(let [snap (require :snap)
      general (snap.get :producer.ripgrep.general)]
  (fn [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
      (general [:--vimgrep :--hidden request.filter] cwd request))))
