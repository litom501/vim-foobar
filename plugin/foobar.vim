scriptencoding utf-8
" Assist in entering placeholder variables, names and text
" Author  : Koji Sato <litom501+vim@gmail.com>
" License : MIT License

let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_foobar')
  finish
endif
let g:loaded_foobar = 1

function! s:echo_undefined_query_key(id) abort
  echo '[foobar] undefined query key'
endfunction

function! FooBar(key) abort
  let result = foobar#query(a:key)
  if empty(result)
    call timer_start(100, function('foobar#_echo_undefined_query_key', [a:key]))
    return ''
  else
    return result
  endif
endfunction

command! -nargs=1 FooBar execute 'normal' 'a<C-R>=FooBar(''' . <f-args> .''')<ESC><ESC>'

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: tabstop=2 shiftwidth=2 expandtab
