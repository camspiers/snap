(let [snap (require :snap)
      tbl (snap.get :common.tbl)]
  (fn [producer]
    "Provides a method to avoid running passed producer multiple times"
    (var cache [])
    (fn [request]
      (if (= (length cache) 0)
        (each [results (snap.consume producer request)]
          (if
            (> (length results) 0)
            (do
              (tbl.accumulate cache results)
              (coroutine.yield results))
            (snap.continue)))
        cache))))

