(fn [line]
  "Parses a line in grep format"
  (let [parts (vim.split (tostring line) ":")]
    {:filename (. parts 1)
     :lnum (tonumber (. parts 2))
     :text (. parts 3)}))
