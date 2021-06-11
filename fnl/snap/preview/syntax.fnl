(let [has-treesitter (pcall require :nvim-treesitter)
      (_ highlight) (pcall require :nvim-treesitter.highlight)
      (_ parsers) (pcall require :nvim-treesitter.parsers)]
  (fn [path bufnr]
    (local fake-path (.. (vim.fn.tempname) "/" path))
    (vim.api.nvim_buf_set_name bufnr fake-path)
    (vim.api.nvim_buf_call bufnr (fn []
      ;; Use the fake path to enable ftdetection
      (local eventignore (vim.api.nvim_get_option "eventignore"))
      (vim.api.nvim_set_option "eventignore" "FileType")
      (vim.api.nvim_command "filetype detect")
      (vim.api.nvim_set_option "eventignore" eventignore)))
    ;; Add syntax highlighting
    (local filetype (vim.api.nvim_buf_get_option bufnr "filetype"))
    (when
      (not= filetype "")
      (if
        has-treesitter
        (let [lang (parsers.ft_to_lang filetype)]
          (if
            (parsers.has_parser lang)
            (highlight.attach bufnr lang)
            (vim.api.nvim_buf_set_option bufnr "syntax" filetype)))
        (vim.api.nvim_buf_set_option bufnr "syntax" filetype)))))
