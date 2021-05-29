(let [snap (require :snap)
      select (snap.get :select.vimgrep)]

  ;; TODO improve this approach
  (local max-size 100000)

  (fn [request]
    (local selection (select.parse request.selection))
    (local path (snap.sync (partial vim.fn.fnamemodify selection.filename ":p")))
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
    (when (not (request.canceled))
      (snap.sync (fn []
        ;; Highlight using the cursor
        (vim.api.nvim_win_set_option request.winnr :cursorline true)
        ;; Set the preview
        (vim.api.nvim_buf_set_lines request.bufnr 0 -1 false preview)
        ;; In case it's accidently saved
        (local fake-path (.. (vim.fn.tempname) "%" (vim.fn.fnamemodify request.selection ":p:gs?/?%?")))
        ;; Use the fake path to enable ftdetection
        (vim.api.nvim_buf_set_name request.bufnr fake-path)
        ;; Detect the file type
        (vim.api.nvim_buf_call request.bufnr (partial vim.api.nvim_command "filetype detect"))
        ;; Try to set cursor to appropriate line
        (when (and (not= encoding :binary) (<= selection.lnum (length preview)))
          (vim.api.nvim_win_set_cursor request.winnr [selection.lnum selection.col])))))))
