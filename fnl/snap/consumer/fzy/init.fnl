(let [filter (require :snap.consumer.fzy.filter)
      score (require :snap.consumer.fzy.score)
      cache (require :snap.consumer.cache)]
  (fn [producer]
    (score (filter (cache producer)))))

