(module snap.select.vim.currentbuffer {require {select-file snap.select.common.file}})

(def select (select-file (fn [selection] {:path selection.filename :lnum selection.row})))
