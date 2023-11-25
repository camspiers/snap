(local snap (require :snap))
(local file (require :snap.preview.common.file))
(local parse (require :snap.common.vimgrep.parse))

(file
  (fn [selection]
    (local {: filename :lnum line :col column} (parse (tostring selection)))
    {:path (snap.sync (partial vim.fn.fnamemodify filename ":p"))
     : line
     : column}))
