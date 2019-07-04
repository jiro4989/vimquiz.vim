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

  let l:datas = vimquiz#data#get_datas()

  " 問題の数だけループし、全問回答するまでループする。
  " このとき quit と入力するとクイズの途中でも強制終了する
  let l:ok_cnt = 0
  let l:results = []
  for l:data in l:datas
    " 問題描画バッファ内のテキストを全て消す
    call s:clear_buffer()

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
    elseif l:ans == 'quit'
      " 途中でも強制的にクイズを終了する
      call s:clear_buffer()
      call setline(1, 'Quit VimQuiz')
      return
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
  silent edit 'vimquiz'
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

function! s:clear_buffer() abort
  for l:i in range(1, winheight('.'))
    call setline(l:i, '')
  endfor
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
