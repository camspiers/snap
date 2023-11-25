(local snap (require :snap))
(local file (require :snap.preview.common.file))

(file
  (fn [selection]
    {:path (snap.sync (partial vim.fn.fnamemodify selection.file ":p"))
     :line (. selection.pos 2)
     :column (. selection.pos 3)}))
