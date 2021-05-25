(module snap.producer.ripgrep.file {require {general snap.producer.ripgrep.general}})

(defn create [request]
  (general.create [:--files :--no-ignore :--hidden] request))
