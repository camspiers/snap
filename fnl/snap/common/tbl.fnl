(module snap.common.tbl)

;; fnlfmt: skip
(defn accumulate [tbl vals]
  "Accumulates non nil values"
  (when (not= vals nil)
    (each [_ value (ipairs vals)]
      (when (not= value "")
        (table.insert tbl value)))))

;; Takes 
(defn take [tbl num]
  "Takes the first n values from tbl"
  [(unpack tbl 1 num)])

;; Table sum
(defn sum [tbl]
  "Sums table"
  (var count 0)
  (each [_ val (ipairs tbl)]
    (set count (+ count val)))
  count)

(defn first [tbl]
  "Gets the first value from the table"
  (when tbl (. tbl 1)))

;; Used for allocating all total in a number of parts without remainder
(defn allocate [total divisor]
  "Divides by allocation, ensuing remainers are handled"
  (var remainder total)
  (local parts [])
  (local part (math.floor (/ total divisor)))
  (for [i 1 divisor]
    (if
      (= i divisor)
      (table.insert parts remainder)
      (do
        (table.insert parts part)
        (set remainder (- remainder part)))))
  parts)

;; Partition for quick sort
(fn partition [tbl p r comp]
  "Partitions a tbl"
  (let [x (. tbl r)]
    (var i (- p 1))
    (for [j p (- r 1) 1]
      (when (comp (. tbl j) x)
        (set i (+ i 1))
        (local temp (. tbl i))
        (tset tbl i (. tbl j))
        (tset tbl j temp)))
    (local temp (. tbl (+ i 1)))
    (tset tbl (+ i 1) (. tbl r))
    (tset tbl r temp)
    (+ i 1)))

;; fnlfmt: skip
(defn partial-quicksort [tbl p r m comp]
  "Partial quicksort for avoiding completely sorting tables when not needed"
  (when (< p r)
    (let [q (partition tbl p r comp)]
      (partial-quicksort tbl p (- q 1) m comp)
      (when (< p (- m 1))
        (partial-quicksort tbl (+ q 1) r m comp)))))
