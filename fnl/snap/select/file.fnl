(module snap.select.file {require {select-file snap.select.common.file}})

(defn multiselect [selections winnr]
  (each [index selection (ipairs selections)]
    (select selection (if (= (length selections) index) winnr false))))

(def select (select-file (fn [selection] {:path (tostring selection)})))
