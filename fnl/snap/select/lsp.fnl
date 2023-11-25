(local file (require :snap.select.common.file))

(local select (file (fn [{: filename :lnum line :col column}] {: filename : line : column})))

(fn autoselect [{: user_data : offset_encoding}]
  (vim.lsp.util.jump_to_location user_data offset_encoding true))

{: select
 : autoselect}
