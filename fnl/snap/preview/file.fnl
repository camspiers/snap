(local snap (require :snap))
(local file (require :snap.preview.common.file))

(file
  (fn [selection]
    {:path (snap.sync (partial vim.fn.fnamemodify (tostring selection) ":p"))
     :line nil
     :column nil}))
