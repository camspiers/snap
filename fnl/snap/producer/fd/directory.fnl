(let [snap (require :snap)
      general (require :snap.producer.fd.general)]
  (fn [request] (general [:-H :-I :-t :d] request)))
