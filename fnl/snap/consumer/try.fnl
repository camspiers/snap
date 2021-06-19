(let [snap (require :snap)
      tbl (snap.get :common.tbl)]
  (fn [...]
    "Tries each subsequent producer, ending with the first producer that yields results"
    (let [producers [...]]
      (fn [request]
        (each [_ producer (ipairs producers)]
          (var had-values false)
          (each [results (snap.consume producer request)]
            (when (and (= (type results) :table) (> (length results) 0))
              (set had-values true))
            (coroutine.yield results))
          (when had-values (coroutine.yield nil)))))))
