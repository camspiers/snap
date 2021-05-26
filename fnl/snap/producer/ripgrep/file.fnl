(let [snap (require :snap)
      general (require :snap.producer.ripgrep.general)]
  (fn [request]
    (let [cwd (snap.sync vim.fn.getcwd)]
      (general [:--files :--no-ignore :--hidden] cwd request))))
