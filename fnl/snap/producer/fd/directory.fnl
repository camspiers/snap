(let [snap (require :snap)
      general (snap.get :producer.fd.general)]
  (fn [request]
    (general [:-H :-I :-t :d] request)))

