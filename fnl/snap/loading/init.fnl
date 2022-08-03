(fn center-with-text-width [text text-width width]
  "Centers by using a text width"
  (let [space (string.rep " " (/ (- width text-width) 2))]
    (.. space text)))

(fn center [text width]
  "Center text for loading screen"
  (center-with-text-width text (string.len text) width))

(fn [width height counter]
  "Create a basic loading screen"
  (local dots (string.rep "." (% counter 5)))
  (local space (string.rep " " (- 5 (string.len dots))))
  (local loading-with-dots (.. "│" space dots " Loading " dots space "│")) 
  (local text-width (string.len loading-with-dots))
  (local loading [])

  (for [_ 1 (- (math.floor (/ height 2)) 1)]
    (table.insert loading ""))

  (table.insert loading
    (center-with-text-width (.. "╭" (string.rep "─" 19) "╮") text-width width))
  (table.insert loading (center loading-with-dots width))
  (table.insert loading
    (center-with-text-width (.. "╰" (string.rep "─" 19) "╯") text-width width))
  loading)
