(let [snap (require :snap)
      general (snap.get :producer.tags.general)]
  (fn [request]
    (general request
             {:args ["-d" request.filter]})))
