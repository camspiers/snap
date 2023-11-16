(let [snap (require :snap)]
  ((snap.get :preview.common.create-file-preview)
    (fn [selection]
      {:path (snap.sync (partial vim.fn.fnamemodify (tostring selection) ":p"))
       :line nil
       :column nil})))
