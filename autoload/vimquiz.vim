let s:save_cpo = &cpo
set cpo&vim

" Vimの操作方法のクイズを開始する
" ===============================
"
" 処理概要
" --------
"
" 1. バッファを3つ使う
" 2. 上のバッファには選択式の問題が表示される
" 3. コマンドバッファに入力し、Enterで決定する
" 4. 正解の場合は、問題描画のバッファの下のバッファに問題タイトルとOK/NGが追記さ
"    れる
" 5. この関数の引数の値によって問題数が変動する
"
" 引数
" ----
"
" 1. 出題するクイズの問題数
function! vimquiz#start_quiz()
  call s:init_buffer()

  " " 新規バッファを生成する
  " :5new vimquiz_q_buf
  " :20new vimquiz_a_buf
  " let s:q_buf_id = bufnr('vimquiz_q_buf')
  " let s:a_buf_id = bufnr('vimquiz_a_buf')

  let l:datas = [
        \ {'q':'Q. ノーマルモードで左に移動する際に使用するキーを答えよ', 'a':'h'},
        \ {'q':'Q. ノーマルモードで下に移動する際に使用するキーを答えよ', 'a':'j'},
        \ {'q':'Q. ノーマルモードで上に移動する際に使用するキーを答えよ', 'a':'k'},
        \ {'q':'Q. ノーマルモードで右に移動する際に使用するキーを答えよ', 'a':'l'}
        \ ]

  " 問題を問題のみ定義したファイルから読み取る。
  " 問題の数だけループし、全部正解か不正解になったらループを終了する
  " このとき quit と入力するとクイズの途中でも強制終了する
  let l:ok_cnt = 0
  let l:results = []
  for l:data in l:datas
    " 問題描画バッファの初期化

    " 問題描画バッファに問題を描画
    call setline(1, l:data['q'])
    call setline(2, '')
    call s:draw_answers(3, l:ok_cnt, len(l:datas), l:results)

    " ユーザの回答の入力待ち
    let l:ans = input('Your answer > ')

    " 正答判定
    let l:ok_ng = ''
    if l:ans == l:data['a']
      let l:ok_cnt += 1
      let l:ok_ng = '[OK]'
    else
      let l:ok_ng = '[NG]'
    endif

    call add(l:results, l:ok_ng . ' ' . l:data['q'])
  endfor

  call s:draw_answers(3, l:ok_cnt, len(l:datas), l:results)

  " 正答数を描画し、あなたのVimレベルを評価する。
  " 入力によって、それをファイル出力できる。
  " 出力フォーマットは以下の通り。
  "
  " 1. プレーンテキスト
  " 2. CSV
  " 3. Markdown
  " 4. AsciiDoc
endfunction

function! s:init_buffer() abort
  silent edit 'vim quiz'
  setlocal bufhidden=hide
  setlocal buftype=nofile
  setlocal colorcolumn=
  setlocal foldcolumn=0
  setlocal hidden
  setlocal nobuflisted
  setlocal nofoldenable
  setlocal nolist
  setlocal nomodeline
  setlocal nonumber
  setlocal norelativenumber
  setlocal nospell
  setlocal noswapfile
  setlocal nowrap
  setlocal winfixheight
  syn match VimQuizOK '^\[OK\].*'
  hi VimQuizOK ctermfg=green guifg=green
  syn match VimQuizNG '^\[NG\].*'
  hi VimQuizNG ctermfg=red guifg=red
endfunction

function! s:draw_answers(start_idx, ok_cnt, q_cnt, results) abort
  " 何問中何問正解していたのかを描画
  call setline(a:start_idx, 'OK/Q : ' . a:ok_cnt . '/' . a:q_cnt)
  call setline(a:start_idx + 1, '')

  " 正解不正解のリストを描画
  let l:i = 0
  for l:result in a:results
    call setline(a:start_idx + 2 + l:i, l:result)
    let l:i += 1
  endfor

  redraw
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
