" projectroot.vim - automatic guessing of projectroots
" Maintainer: Daan O. Bakker
" Version:    1.2
" License:    The same license as Vim itself, see `:h license`

if &cp || exists('loaded_projectroot')
  finish
endif
let loaded_projectroot = 1

" Commands {{{1
command! -nargs=* -complete=command ProjectRootExe :call projectroot#exe([<f-args>])
command! -nargs=? -complete=file ProjectRootCD :call projectroot#cd("<args>", "cd")
command! -nargs=? -complete=file ProjectRootLCD :call projectroot#cd("<args>", "lcd")

command! -nargs=? -complete=file ProjectBufArgs :exe 'args' join(projectroot#buffers("<args>"))
command! -nargs=? -bang -complete=file ProjectBufFirst :exe 'b<bang>' projectroot#buffers("<args>")[0]
command! -nargs=? -bang -complete=file ProjectBufLast :exe 'b<bang>' projectroot#buffers("<args>")[-1]
command! -nargs=* -bang -complete=command ProjectBufDo :call projectroot#bufdo([<f-args>], '<bang>')
command! -nargs=? -bang -complete=file ProjectBufNext :exe 'b<bang>' projectroot#bufnext(1, "<args>")
command! -nargs=? -bang -complete=file ProjectBufPrev :exe 'b<bang>' projectroot#bufnext(-1, "<args>")

" Deprecated methods {{{1
" (Deprecated since version 1.2)

function! ProjectRootGet(...)
  return call('projectroot#get', a:000)
endfunction
function! ProjectRootGuess(...)
  return call('projectroot#guess', a:000)
endfunction
function! ProjectRootCD(...)
  return call('projectroot#cd', a:000)
endfunction
function! ProjectRootExe(...)
  return call('projectroot#exe', a:000)
endfunction
function! ProjectBuffers(...)
  return call('projectroot#buffers', a:000)
endfunction
function! ProjectBufNext(...)
  return call('projectroot#bufnext', a:000)
endfunction
