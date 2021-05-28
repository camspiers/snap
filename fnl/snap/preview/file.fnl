(let [snap (require :snap)]
  (local max-size 5000)
  (fn [request]
    (local path (snap.sync (partial vim.fn.fnamemodify request.selection ":p")))
    (local handle (io.popen (string.format "file -n -b --mime-encoding %s" path)))
    (local encoding (string.gsub (handle:read "*a") "^%s*(.-)%s*$" "%1") )
    (handle:close)

    ;; Read the data only for non-binary files
    (local preview (if
      (= encoding :binary)
      ["Binary file"]
      (do
        (local fd (assert (vim.loop.fs_open path "r" 438)))
        (local stat (assert (vim.loop.fs_fstat fd)))
        (local data (assert (vim.loop.fs_read fd (math.min stat.size max-size) 0)))
        (assert (vim.loop.fs_close fd))
        (vim.split data "\n" true))))

    ;; Write the preview to the buffer.
    (when (not request.cancel)
      (snap.sync (fn []
        ;; Set the preview
        (vim.api.nvim_buf_set_lines request.bufnr 0 -1 false preview)
        ;; In case it's accidently saved
        (local fake-path (.. (vim.fn.tempname) "%" (vim.fn.fnamemodify request.selection ":p:gs?/?%?")))
        ;; Use the fake path to enable ftdetection
        (vim.api.nvim_buf_set_name request.bufnr fake-path)
        ;; Detect the file type
        (vim.api.nvim_buf_call request.bufnr (partial vim.api.nvim_command "filetype detect")))))))
