Projectroot
===========
There already are a ton of plugins (such as CtrlP) that try to guess what the
main project folder is of a file that you're working on, but this plugin allows
to easily re-use that functionality in your own custom mappings or scripts.

Features
--------
  * Works out-of-the-box on most projects by detecting folders such as `.git`.
  * Very customizeable.
  * Easy to use in mappings and your own scripts, just call `ProjectRootGuess()`
    to get the project root of the current file or `ProjectRootGuess(file)`
    for another file.
  * Can be combined with existing plugins (see Examples)
  * Tries to be as lightweight as possible. Only searches for a project root
    when a method such as `ProjectRootGuess` is used.

Methods provided
----------------
  * `ProjectRootGuess([file])`: Returns the project root for the given file
    (or for the current file if none is given).
  * `ProjectRootExe(cmd)`: Temporarily changes the current directory to that
    of the project root, then executes the command.
  * `ProjectRootCD([file])`: Changes the current directory to project root of
    the given file.
  * `ProjectRootBuffers([file])`: Returns all buffers belonging to the same
    project of the given file.

Examples
--------
### Change current working directory to project root
Using a mapping:

    nnoremap <leader>dp :ProjectRootCD<cr>

Automatically:

    au BufEnter * if &ft != 'help' | call ProjectRootCD() | endif

### Grep
To grep with your project as base directory, you could add something like:

    nnoremap <Leader>g :ProjectRootExe grep<space>

### Open file relative to the root
To start the command line with `:e /my/path/to/project/`, you could use this:

    fun! EditProjectDir()
      return ':e '.ProjectRootGuess().'/'
    endf

    nnoremap <expr> <leader>ep EditProjectDir()

### NERDTree
If you would like NERDTree to always open at the root of your project, try
adding something like this to your vim config:

    nnoremap <silent> <Leader>dt :ProjectRootExe NERDTreeFind<cr>

Changing which folder is detected as root
-----------------------------------------
There are several ways to do this:

  * Creating a `.projectroot` file in the folder which you would like to be
    the root of the file of the buffer
  * Changing the markers that are used to detect files by changing the
    `g:rootmarkers` variable.
  * Setting the `b:projectroot` variable in that buffer (using an autocommand
    or script).

For plugin authors
------------------
If you would like to make our plugins compatible that would be cool! I think
a method like this might be the way to go (so that nothing breaks if the user
didn't install both plugins):

    fun! s:guessprojectroot()
      if exists('loaded_projectroot')
        return ProjectRootGuess()
      endif
      return expand('%:p:h') " Just guess it is the directory of the current file
    endf

Similar projects
----------------
  * [Vim Rooter](https://github.com/airblade/vim-rooter): Changes the working
    directory to the project root when you open a file.
  * [vimprj](https://github.com/vim-scripts/vimprj): Allows the execution of
    project or folder specific scripts.
  * [CtrlP](https://github.com/kien/ctrlp.vim): Has an option to search
    for files relative to the root directory of your project.
