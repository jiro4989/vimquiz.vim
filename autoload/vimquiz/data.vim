let s:datas = [
      \ {'q':'Q. ノーマルモードで左に移動する際に使用するキーを答えよ', 'a':'h'},
      \ {'q':'Q. ノーマルモードで下に移動する際に使用するキーを答えよ', 'a':'j'},
      \ {'q':'Q. ノーマルモードで上に移動する際に使用するキーを答えよ', 'a':'k'},
      \ {'q':'Q. ノーマルモードで右に移動する際に使用するキーを答えよ', 'a':'l'}
      \ ]

function! vimquiz#data#get_datas() abort
  return s:datas
endfunction
