(let [snap (require :snap)
      general (snap.get :producer.fd.general)]
  (fn [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
      (general [:-H :-I] cwd request))))
