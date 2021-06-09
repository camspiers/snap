(module snap.common.tbl)

(defn accumulate [tbl vals]
  "Accumulates non nil values"
  (when (not= vals nil)
    (each [_ value (ipairs vals)]
      (when (not= (tostring value) "")
        (table.insert tbl value)))))

(defn concat [tbl-a tbl-b]
  "Concatenates tables"
  (let [tbl []]
    (accumulate tbl tbl-a)
    (accumulate tbl tbl-b)
    tbl))

(defn take [tbl num]
  "Takes the first n values from tbl"
  (local partial-tbl [])
  (each [_ value (ipairs tbl) :until (= num (length partial-tbl))]
    (table.insert partial-tbl value))
  partial-tbl)

(defn sum [tbl]
  "Sums table"
  (var count 0)
  (each [_ val (ipairs tbl)]
    (set count (+ count val)))
  count)

(defn first [tbl]
  "Gets the first value from the table"
  (when tbl (. tbl 1)))

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

(defn partial-quicksort [tbl p r m comp]
  "Partial quicksort for avoiding completely sorting tables when not needed"
  (when (< p r)
    (let [q (partition tbl p r comp)]
      (partial-quicksort tbl p (- q 1) m comp)
      (when (< p (- m 1))
        (partial-quicksort tbl (+ q 1) r m comp)))))
