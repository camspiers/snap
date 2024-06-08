(let [snap (require :snap)
      general (snap.get :producer.tags.general)]
  (fn [request]
    (general request
             {:args ["-r" request.filter]})))
