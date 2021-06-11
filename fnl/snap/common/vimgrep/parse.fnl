(fn [line]
  "Parses a line in vimgrep format"
  (let [parts (vim.split (tostring line) ":")]
    {:filename (. parts 1)
     :lnum (tonumber (. parts 2))
     :col (tonumber (. parts 3))
     :text (. parts 4)}))
