(let [filter (require :snap.consumer.fzy.filter)
      score (require :snap.consumer.fzy.score)
      positions (require :snap.consumer.fzy.positions)
      cache (require :snap.consumer.cache)]
  (fn [producer]
    (positions (score (filter (cache producer))))))

