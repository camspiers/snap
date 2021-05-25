(let [snap (require :snap)]
  (fn [producer]
    "Provides a method to avoid running passed producer multiple times"
    (var cache [])
    (fn [request]
      (if (= (length cache) 0)
        (each [results (snap.consume producer request)]
          (snap.accumulate cache results)
          (coroutine.yield results))
        cache))))

