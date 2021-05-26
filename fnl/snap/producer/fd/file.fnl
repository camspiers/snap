(let [snap (require :snap)
      general (require :snap.producer.fd.general)]
  (fn [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
      (general [:-H :-I] cwd request))))
