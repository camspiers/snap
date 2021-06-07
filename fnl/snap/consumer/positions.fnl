(let [snap (require :snap)]
  (fn get-positions [result filter]
    (if
      (= filter "")
      []
      (do
        (local positions [])
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
                (table.insert positions index))
              (lua "break"))))
        positions)))

  (fn [producer]
    (fn [request]
      (each [data (snap.consume producer request)]
        (match (type data)
          :table (if
                   (= (length data) 0)
                   (snap.continue)
                   (coroutine.yield
                     (vim.tbl_map
                       #(snap.with_meta $1 :positions (get-positions $1 request.filter))
                       data)))
          :nil (coroutine.yield nil))))))
