(let [snap (require :snap)
      general (snap.get :producer.luv.general)]
  (fn [request]
    (general {:file true} (snap.sync vim.fn.getcwd))))
