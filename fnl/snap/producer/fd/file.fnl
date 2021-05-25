(module snap.producer.fd.file {require {general snap.producer.fd.general}})

(defn create [request]
  (general.create [:-HI] request))
