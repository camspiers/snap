(module snap.producer.ripgrep.vimgrep {require {general snap.producer.ripgrep.general}})

(defn create [request]
  (general.create [:--vimgrep :--hidden request.filter] request))
