(let [snap (require :snap)
      parse (snap.get :common.vimgrep.parse)]
  ((snap.get :preview.common.create-file-preview)
    (fn [selection]
      (local parsed-selection (parse (tostring selection)))
      {:path (snap.sync (partial vim.fn.fnamemodify parsed-selection.filename ":p"))
       :line parsed-selection.lnum
       :column parsed-selection.col})))
