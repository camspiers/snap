(module snap.consumer.fzy.score {require {snap snap
                                          fzy fzy}})

;; fnlfmt: skip
(defn create [producer]
  "Scores the result set"
  (fn [request]
    (each [results (snap.consume producer request)]
      (match (type results)
        "table" (coroutine.yield (vim.tbl_map
                  #(snap.with_meta $1 :score (fzy.score request.filter (tostring $1)))
                  results))
        "nil" (coroutine.yield nil)))))
