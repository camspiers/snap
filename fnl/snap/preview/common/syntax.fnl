(let [snap-io (require :snap.common.io)]
  (fn [file-name bufnr]
    (local fake-path (.. (vim.fn.tempname) "/" file-name))
    (pcall vim.api.nvim_buf_set_name bufnr fake-path)
    (local filetype (or (vim.filetype.match {:filename file-name}) ""))

    (when (not= filetype "")
      (vim.api.nvim_set_option_value "filetype" filetype {:buf bufnr})
      (local lang (or (vim.treesitter.language.get_lang filetype) filetype))
      (local (ts-ok? _) (pcall vim.treesitter.start bufnr lang))
      (when (not ts-ok?)
        (vim.api.nvim_set_option_value "syntax" filetype {:buf bufnr})))))
