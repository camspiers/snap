(let [all (require :snap.consumer.fzy.all)
      cache (require :snap.consumer.cache)]
  (fn [producer]
    (all (cache producer))))

