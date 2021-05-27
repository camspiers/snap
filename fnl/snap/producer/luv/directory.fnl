(let [snap (require :snap)
      general (snap.get :producer.luv.general)]
  (fn [request]
    (general {:directory true} (snap.sync vim.fn.getcwd))))
