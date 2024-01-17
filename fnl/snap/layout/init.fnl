(module snap.layout)

;; Global accessible layouts
;; Currently layouts always have the input placed below and therefore room
;; must be left available for it to fit

;; Helper to get lines
(defn lines []
  (vim.api.nvim_get_option :lines))

;; Helper to get columns
(defn columns []
  (vim.api.nvim_get_option :columns))

(defn percent [size percent]
  (math.floor (* size percent)))

(fn size [%width %height]
  {:width (math.floor (* (columns) %width))
   :height (math.floor (* (lines) %height))})

(fn from-bottom [size offset]
  (- (lines) size offset))

;; The middle for the height or width requested (from top or left)
(defn middle [total size]
  (math.floor (/ (- total size) 2)))

(defn %centered [%width %height]
  "Defines a centered layout based on percent"
  (let [{: width : height} (size %width %height)]
    {: width
     : height
     :row (middle (lines) height)
     :col (middle (columns) width)}))

(defn %bottom [%width %height]
  "Defines a bottom layout based on percent"
  (let [{: width : height} (size %width %height)]
    {: width
     : height
     :row (from-bottom height 8)
     :col (middle (columns) width)}))

(defn %top [%width %height]
  "Defines a top layout based on percent"
  (let [{: width : height} (size %width %height)]
    {: width : height :row 5 :col (middle (columns) width)}))

;; Primary available layouts: centered, bottom, top

(defn centered []
  (%centered 0.9 0.7))

(defn bottom []
  (let [lines (vim.api.nvim_get_option :lines)
        height (math.floor (* lines 0.5))
        width (vim.api.nvim_get_option :columns)
        col 0
        row (- lines height 4)]
    {: width : height : col : row }))

(defn top []
  (%top 0.9 0.7))
