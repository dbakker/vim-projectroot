" projectroot.vim - automatic guessing of projectroots
" Maintainer: Daan O. Bakker
" Version:    1.0
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
  let fullfile = a:0 ? fnamemodify(expand(a:1), ':p') : expand('%:p')
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
  let r = a:0 && len(a:1) ? ProjectRootGuess(a:1) : ProjectRootGuess()
  exe 'cd '.r
endf
command! -nargs=? -complete=file ProjectRootCD :call ProjectRootCD('<args>')

" ProjectRootExe(cmd): executes cmd from within the project directory {{{1
fun! ProjectRootExe(cmd)
  let olddir = getcwd()
  try
    ProjectRootCD
    exe a:cmd
  finally
    exe 'cd '.olddir
  endtry
endfun
command! -nargs=* -complete=command ProjectRootExe :call ProjectRootExe('<args>')

" ProjectRootBuffers([file]): returns all buffers from the same project {{{1
fun! ProjectRootBuffers(...)
  let fullfile = a:0 ? fnamemodify(expand(a:1), ':p') : expand('%:p')
  let root = ProjectRootGuess(fullfile)
  let bufs = []
  for b in s:getallbuffers()
    let file = bufname(b)
    let file = fnamemodify(b, ':p')
    if stridx(file, root)==0
      call add(bufs, file)
    endif
  endfor
  return bufs
endf

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
endfunction
