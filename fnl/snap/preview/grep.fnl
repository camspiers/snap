(local snap (require :snap))
(local file (require :snap.preview.common.file))
(local parse (require :snap.common.grep.parse))

(file
  (fn [selection]
    (local {: filename :lnum line } (parse (tostring selection)))
    {:path (snap.sync (partial vim.fn.fnamemodify filename ":p"))
     : line
     :column 0}))
