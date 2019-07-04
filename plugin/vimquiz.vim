if exists("g:loaded_vimquiz")
  finish
endif
let g:loaded_vimquiz = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists(":VimQuizStart")
  command! -nargs=0 VimQuizStart call vimquiz#start_quiz()
  nnoremap X :VimQuizStart<CR>
endif

let &cpo = s:save_cpo
unlet s:save_cpo
