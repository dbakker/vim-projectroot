" projectroot.vim - automatic guessing of projectroots
" Maintainer: Daan O. Bakker
" Version:    1.1
" License:    The same license as Vim itself, see `:h license`

if &cp || exists('loaded_projectroot')
  finish
endif
let loaded_projectroot = 1

" Options {{{1
if !exists('g:rootmarkers')
  let g:rootmarkers = ['.projectroot', '.git', '.hg', '.svn', '.bzr', '_darcs', 'build.xml']
endif

" ProjectRootGuess([file]): guesses and returns the project root {{{1
fun! ProjectRootGuess(...)
  let fullfile = s:getfullname(a:0 ? a:1 : '')
  if exists('b:projectroot')
    if stridx(fullfile, fnamemodify(b:projectroot, ':p'))==0
      return b:projectroot
    endif
  endif
  for marker in g:rootmarkers
    let result=''
    let pivot=fullfile
    while pivot!=fnamemodify(pivot, ':h')
      let pivot=fnamemodify(pivot, ':h')
      if len(glob(pivot.'/'.marker))
        let result=pivot
      endif
    endwhile
    if len(result)
      return result
    endif
  endfor
  return filereadable(fullfile) ? fnamemodify(fullfile, ':h') : fullfile
endf

" ProjectRootCD([file]): changes directory to the project of the given file {{{1
fun! ProjectRootCD(...)
  exe 'cd' ProjectRootGuess(s:getfullname(a:0 ? a:1 : ''))
endf

command! -nargs=? -complete=file ProjectRootCD :call ProjectRootCD("<args>")

" ProjectRootExe(cmd): executes cmd from within the project directory {{{1
fun! ProjectRootExe(args)
  let olddir = getcwd()
  try
    ProjectRootCD
    exe join(a:args)
  finally
    exe 'cd' olddir
  endtry
endfun

command! -nargs=* -complete=command ProjectRootExe :call ProjectRootExe([<f-args>])

" ProjectBuffers([file]): returns all buffers from the same project {{{1
fun! ProjectBuffers(...)
  let root = ProjectRootGuess(s:getfullname(a:0 ? a:1 : ''))
  let bufs = []
  for b in s:getallbuffers()
    let file = bufname(b)
    let file = fnamemodify(file, ':p')
    if stridx(file, root)==0
      call add(bufs, file)
    endif
  endfor
  call sort(bufs)
  return bufs
endf

command! -nargs=? -complete=file ProjectBufArgs :exe 'args' join(ProjectBuffers("<args>"))
command! -nargs=? -bang -complete=file ProjectBufFirst :exe 'b<bang>' ProjectBuffers("<args>")[0]
command! -nargs=? -bang -complete=file ProjectBufLast :exe 'b<bang>' ProjectBuffers("<args>")[-1]

" ProjectBufDo(cmd, bang): execute the given command for all project buffers {{{1
fun! s:ProjectBufDo(args, bang)
  let cmd=join(a:args)
  let bang=len(a:bang) ? '!':''
  let ei=&ei
  set ei+=Syntax
  try
    for f in ProjectBuffers()
      exe 'b'.bang f
      exe cmd
    endfor
  finally
    let &ei=ei
  endtry
endf

command! -nargs=* -bang -complete=command ProjectBufDo :call <SID>ProjectBufDo([<f-args>], '<bang>')

" ProjectBufNext([count], [file]): returns the next buffer in the project {{{1
fun! ProjectBufNext(count, ...)
  let thisbuf = s:getfullname(a:0 ? a:1 : '')
  let l = ProjectBuffers(thisbuf)

  if !exists('g:projectroot_noskipbufs')
    for i in copy(l)
      if bufwinnr(i)!=-1 && i!=thisbuf
        call remove(l, index(l, i))
      endif
    endfor
  endif

  let i = index(l, thisbuf)
  let i = i>=0 ? i : 0
  let s = len(l)
  let target = (((i+a:count) % s)+s) % s
  return bufnr(get(l, target, thisbuf))
endf

command! -nargs=? -bang -complete=file ProjectBufNext :exe 'b<bang>' ProjectBufNext(1, "<args>")
command! -nargs=? -bang -complete=file ProjectBufPrev :exe 'b<bang>' ProjectBufNext(-1, "<args>")

" Utility methods {{{1
fun! s:getallbuffers()
  let all = range(1, bufnr('$'))
  let res = []
  for b in all
    if buflisted(b)
      call add(res, bufname(b))
    endif
  endfor
  return res
endf

fun! s:getfullname(f)
  let f = a:f
  let f = f=~"'." ? s:getmarkfile(f[1]) : f
  let f = len(f) ? f : expand('%')
  return fnamemodify(f, ':p')
endf

fun! s:getmarkfile(mark)
  try
    let message=''
    redir => message
    sil exe ':marks' a:mark
    redir END
    let lines=split(message, '\n')
    let lastline=split(lines[len(lines)-1])
    let f = expand(lastline[len(lastline)-1])
    return filereadable(f) ? f : ''
  catch
    return ''
  endtry
endf