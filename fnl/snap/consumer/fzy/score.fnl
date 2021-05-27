(let [snap (require :snap)
      fzy (require :fzy)]
  (fn [producer]
    "Scores the result set"
    (fn [request]
      (each [results (snap.consume producer request)]
        (match (type results)
          "table" (coroutine.yield (vim.tbl_map
                    #(snap.with_meta $1 :score (if
                                                 (not= request.filter "")
                                                 (fzy.score request.filter (tostring $1))
                                                 0))
                    results))
          "nil" (coroutine.yield nil))))))
