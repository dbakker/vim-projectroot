Projectroot
===========
There already are a ton of plugins (such as CtrlP) that try to guess what the
main project folder is of a file that you're working on, but this plugin allows
to easily re-use that functionality in your own custom mappings or scripts.

Features
--------
  * Works out-of-the-box on most projects by detecting folders such as `.git`.
  * Very customizeable.
  * Easy to use in mappings and your own scripts, just use `:ProjectRootCD` or
    call `ProjectRootGuess()` to get the project root of the current file.
  * Can be combined easily with existing plugins. (see Examples)
  * Tries to be as lightweight as possible. For example, it only searches for
    a project root when a method such as `ProjectRootGuess` is used and does not
    automatically set any mappings or autocommands.

Installation
------------
If you're using [pathogen.vim](https://github.com/tpope/vim-pathogen) execute:

    cd ~/.vim/bundle
    git clone git://github.com/dbakker/vim-projectroot.git

That's all!

However, to avoid having to type in long commands all the time, you will
probably want to set up some mappings. For this, check out the examples below or
consult [the
documentation](https://github.com/dbakker/vim-projectroot/blob/master/doc/projectroot.txt).

Examples
--------
### Change current working directory to project root
Using a mapping:

    nnoremap <leader>dp :ProjectRootCD<cr>

Automatically whenever you open a buffer:

```vim
function! <SID>AutoProjectRootCD()
  try
    if &ft != 'help'
      ProjectRootCD
    endif
  catch
    " Silently ignore invalid buffers
  endtry
endfunction

autocmd BufEnter * call <SID>AutoProjectRootCD()
```

### Grep
To grep with your project as base directory, you could add something like:

    nnoremap <leader>g :ProjectRootExe grep<space>

### Open file relative to the root
To start the command line with `:e /my/path/to/project/`, you could use this:

    nnoremap <expr> <leader>ep ':edit '.projectroot#guess().'/'

### NERDTree
If you would like NERDTree to always open at the root of your project, try
adding something like this to your vim config:

    nnoremap <silent> <leader>dt :ProjectRootExe NERDTreeFind<cr>

### Switching between files
These mappings might be handy to navigate between your project files.

    nnoremap <silent> [p :ProjectBufPrev<cr>
    nnoremap <silent> ]p :ProjectBufNext<cr>
    nnoremap <silent> [P :ProjectBufFirst<cr>
    nnoremap <silent> ]P :ProjectBufLast<cr>

To manage multiple projects, you could use something like:

    nnoremap <silent> ]v :ProjectBufNext ~/.vim<cr>
    nnoremap <silent> [v :ProjectBufPrev ~/.vim<cr>

Or if you had used `mF` to mark a file in a certain project:

    nnoremap <silent> ]f :ProjectBufNext 'F<cr>
    nnoremap <silent> [f :ProjectBufPrev 'F<cr>

Check out [the
documentation](https://github.com/dbakker/vim-projectroot/blob/master/doc/projectroot.txt)
for more information about the different commands and settings!

Similar projects
----------------
  * [Vim Rooter](https://github.com/airblade/vim-rooter): Changes the working
    directory to the project root when you open a file.
  * [vimprj](https://github.com/vim-scripts/vimprj): Allows the execution of
    project or folder specific scripts.
  * [CtrlP](https://github.com/kien/ctrlp.vim): Has an option to search
    for files relative to the root directory of your project.

License
-------

Copyright (c) Daan O. Bakker.  Distributed under the same terms as Vim itself.
See `:help license`.
