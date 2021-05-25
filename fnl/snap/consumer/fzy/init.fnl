(module snap.consumer.fzy {require {filter snap.consumer.fzy.filter
                                    score snap.consumer.fzy.score
                                    cache snap.consumer.cache}})

(defn create [producer]
  (score.create (filter.create (cache.create producer))))

