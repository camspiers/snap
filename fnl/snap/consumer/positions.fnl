(let [snap (require :snap)]
  (fn get-positions [filter result]
    (if
      (= filter "")
      []
      (do
        (local positions {})
        (local filter (string.upper filter))
        (local result (string.upper (tostring result)))
        (each [c (filter:gmatch ".")]
          (var last-index 1)
          (while true
            (local index (result:find c last-index true))
            (if
              (not= index nil)
              (do
                (set last-index (+ index 1))
                (tset positions index true))
              (lua "break"))))
        (vim.tbl_keys positions))))

  (fn [producer]
    (fn [request]
      (each [data (snap.consume producer request)]
        (match (type data)
          :table (if
                   (= (length data) 0)
                   (snap.continue)
                   (fn positions [result]
                     (get-positions request.filter result))
                   (coroutine.yield
                     (vim.tbl_map
                       #(snap.with_meta $1 :positions positions)
                       data)))
          :nil (coroutine.yield nil))))))
