(let [general (require :snap.producer.fd.general)]
  (fn [request] (general [:-H :-I :-t :d] request)))
