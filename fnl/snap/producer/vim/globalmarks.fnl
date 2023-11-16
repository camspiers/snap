(let [snap (require :snap)
      tbl (snap.get :common.tbl)]

  (fn get-marks []
    (vim.tbl_map
      (fn [mark] (snap.with_metas (string.format "%s = %s:%d:%d" mark.mark mark.file (. mark.pos 2) (. mark.pos 3)) mark))
      (vim.fn.getmarklist)))

  (fn [] (snap.sync get-marks)))

