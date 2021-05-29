(let [snap (require :snap)
      fzy (require :fzy)]
  (fn [producer]
    "Scores the result set"
    (fn [request]
      (each [results (snap.consume producer request)]
        (match (type results)
          "table" (coroutine.yield 
                    (if
                      (= request.filter "")
                      results
                      (vim.tbl_map #(snap.with_meta $1 :score (fzy.score request.filter (tostring $1))) results)))
          "nil" (coroutine.yield nil))))))
