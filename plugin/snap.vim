if !has('nvim-0.5')
  echoerr "snap requires nvim > 0.5"
  finish
end

if exists('g:loaded_snap')
  finish
endif

let g:loaded_snap = 1

highlight default link SnapSelect Visual
highlight default link SnapMultiSelect Type

highlight default link SnapNormal Normal
highlight default link SnapBorder SnapNormal

highlight default link SnapPosition IncSearch
highlight default link SnapPrompt Identifier
