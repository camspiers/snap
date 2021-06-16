(module snap.select.help)

(defn select [selection winnr]
  (vim.api.nvim_command (string.format "help %s" (tostring selection))))
