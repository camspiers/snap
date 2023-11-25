(local snap (require :snap))
(local file (require :snap.preview.common.file))

(file
  (fn [{: filename :row line}]
    {:path (snap.sync (partial vim.fn.fnamemodify filename ":p"))
     : line
     :column 1}))
