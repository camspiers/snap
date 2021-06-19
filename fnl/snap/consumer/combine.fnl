(let [snap (require :snap)
      tbl (snap.get :common.tbl)]
  (fn [...]
    "Combines multiple producers"
    (let [producers [...]]
      (fn [request]
        (each [_ producer (ipairs producers)]
          (each [results (snap.consume producer request)]
            (coroutine.yield results)))))))

