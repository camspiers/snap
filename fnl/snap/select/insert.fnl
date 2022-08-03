(module snap.select.insert)

(defn select [selection winnr]
  (vim.api.nvim_put [(tostring selection)] "c" true true))
