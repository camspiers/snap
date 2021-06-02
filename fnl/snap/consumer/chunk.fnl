(fn chunk [size tbl]
  (var index 1)
  (var tbl-size (length tbl))
  (fn []
    (when (> index tbl-size) (lua "return nil"))
    (local chunk [])
    (while
      (and (<= index tbl-size) (< (length chunk) size))
      (table.insert chunk (. tbl index))
      (set index (+ index 1)))
    chunk))

(let [snap (require :snap)]
  (fn [chunk-size producer]
    "Chunks up a producer. Used instead of debouncing"
    (fn [request]
      (each [results (snap.consume producer request)]
        ;; Collect the count of the results
        (if
          (and (= (type results) :table) (> (length results) 0))
          (each [part (chunk chunk-size results)]
            (coroutine.yield part))
          (coroutine.yield results))))))
