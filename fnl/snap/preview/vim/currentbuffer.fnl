(let [snap (require :snap)]
  ((snap.get :preview.common.create-file-preview)
    (fn [selection]
      {:path (snap.sync (partial vim.fn.fnamemodify selection.filename ":p"))
       :line selection.row
       :column 1})))
