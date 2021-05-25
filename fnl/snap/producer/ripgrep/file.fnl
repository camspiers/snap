(let [general (require :snap.producer.ripgrep.general)]
  (fn [request] (general [:--files :--no-ignore :--hidden] request)))
