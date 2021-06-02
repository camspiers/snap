(let [snap (require :snap)
      fzy (require :fzy)]
  (fn [producer]
    "All"
    (fn filter [filter results]
      (if
        (= filter "")
        results
        (let [processed []]
          (each [_ [index positions score] (ipairs (fzy.filter filter results))]
            (table.insert processed (snap.with_metas (. results index) {: positions : score})))
          processed)))

    (fn [request]
      (each [results (snap.consume producer request)]
        (match (type results)
          "table" (coroutine.yield (filter request.filter results))
          "nil" (coroutine.yield nil))))))
