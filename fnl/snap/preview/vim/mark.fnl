(let [snap (require :snap)]
  ((snap.get :preview.common.create-file-preview)
    (fn [selection]
      {:path (snap.sync (partial vim.fn.fnamemodify selection.file ":p"))
       :line (. selection.pos 2)
       :column (. selection.pos 3)})))
