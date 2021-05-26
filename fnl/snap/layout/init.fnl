(module snap.layout)

;; Global accessible layouts
;; Currently layouts always have the input placed below and therefore room
;; must be left available for it to fit

;; Helper to get lines
(fn lines []
  (vim.api.nvim_get_option :lines))

;; Helper to get columns
(fn columns []
  (vim.api.nvim_get_option :columns))

;; The middle for the height or width requested (from top or left)
(fn middle [total size]
  (math.floor (/ (- total size) 2)))

(fn from-bottom [size offset]
  (- (lines) size offset))

(fn size [%width %height]
  {:width (math.floor (* (columns) %width))
   :height (math.floor (* (lines) %height))})

(fn %centered [%width %height]
  (let [{: width : height} (size %width %height)]
    {: width
     : height
     :row (middle (lines) height)
     :col (middle (columns) width)}))

(fn %bottom [%width %height]
  (let [{: width : height} (size %width %height)]
    {: width
     : height
     :row (from-bottom height 8)
     :col (middle (columns) width)}))

(fn %top [%width %height]
  (let [{: width : height} (size %width %height)]
    {: width : height :row 5 :col (middle (columns) width)}))

;; Primary available layouts: centered, bottom, top

(defn centered []
  (%centered 0.8 0.5))

(defn bottom []
  (%bottom 0.8 0.5))

(defn top []
  (%top 0.8 0.5))
