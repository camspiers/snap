(let [snap (require :snap)
      fzy (require :fzy)]
  (fn [producer]
    "Filters each result from the producer using request.filter"
    (fn filter [filter results]
      (if
        (= filter "")
        results
        (vim.tbl_filter #(fzy.has_match filter (tostring $1)) results)))

    (fn [request]
      (each [results (snap.consume producer request)]
        (match (type results)
          "table" (coroutine.yield (filter request.filter results))
          "nil" (coroutine.yield nil))))))
