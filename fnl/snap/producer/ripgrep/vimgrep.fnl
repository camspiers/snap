(let [general (require :snap.producer.ripgrep.general)]
  (fn [request] (general [:--vimgrep :--hidden request.filter] request)))
