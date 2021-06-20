(let [snap (require :snap)]
  (fn [filter-fnc producer]
    "Filters values from producer"
    (fn [request]
      (each [results (snap.consume producer request)]
        (if
          (and (= (type results) :table) (> (length results) 0))
          (coroutine.yield (vim.tbl_filter #(filter-fnc $1 request) results))
          (coroutine.yield results))))))
