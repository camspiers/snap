(let [snap (require :snap)]
  (fn [producer]
    "Scores the result set. Basic scoring based on length, the shorther the better score."
    (fn [request]
      (each [data (snap.consume producer request)]
        (match (type data)
          :table (if
                   (= (length data) 0)
                   (snap.continue)
                   (coroutine.yield
                     (vim.tbl_map #(snap.with_meta $1 :score (- 0 (length (tostring $1)))) data)))
          :nil (coroutine.yield nil))))))
