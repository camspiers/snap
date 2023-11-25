(local file (require :snap.select.common.file))

(local select (file (fn [selection] {:filename (tostring selection)})))

(fn multiselect [selections winnr]
  (each [index selection (ipairs selections)]
    (select selection (if (= (length selections) index) winnr false))))

{: multiselect
 : select}
