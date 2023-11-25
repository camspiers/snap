(local file (require :snap.select.common.file))

{:select (file (fn [{: filename :row line}] {: filename : line}))}
