(let [snap (require :snap)]
  (fn [limit producer]
    "Limit"
    (fn [request]
      (var count 0)
      (each [results (snap.consume producer request)]
        ;; Collect the count of the results
        (when (= (type results) :table) (set count (+ count (length results))))
        ;; When we have reached the limit signal to cancel
        (when (> count limit) (request.cancel))
        (coroutine.yield results)))))

