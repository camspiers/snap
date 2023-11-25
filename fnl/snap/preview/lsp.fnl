(local file (require :snap.preview.common.file))

(file
  (fn [{:filename path :col column :lnum line}]
    {: path
     : column
     : line}))
