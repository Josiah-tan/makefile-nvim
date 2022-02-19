# Makefile-nvim

Telescope integration with makefiles\!

# Plugin Dependencies and Installation

  - Telescope and its dependencies
      - Note that telescope is neovim 0.5 + only
          - so build your neovim from source, or get the latest
            release\!
  - Here is an example using
    [vim-plug](https://github.com/junegunn/vim-plug) here
      - but feel free to use whatever plugin manager that you like\!

<!-- end list -->

``` vim
" This is a requirement, which implements some useful window management
"   items for neovim
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'

" fuzzy finder etc...
Plug 'nvim-telescope/telescope.nvim'    
" compiled fzy sorter (hence faster)
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" for terminal integration
Plug 'ThePrimeagen/harpoon'

"Plugin for Makefile integration
Plug 'Josiah-tan/makefile-nvim'
```

# Setup

  - This setup function is important for initializing the plugin, any
    default options can be set here

<!-- end list -->

``` lua
-- no defaults by default
require("makefile_nvim").setup()
-- using terminal 1 by default
require("makefile_nvim").setup({term = 1})
```

# Mappings

  - below are some mappings that might be useful to use
      - note that if \`selection\` is a string, the make command
        combined with the \`selection\` is sent to the terminal without
        evoking telescope

<!-- end list -->

``` lua
vim.api.nvim_set_keymap("n", "<Leader>mf", ':lua require("makefile_nvim.builtin").makeFile({term = 1})<CR>', {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("n", "<Leader>ma", ':lua require("makefile_nvim.builtin").makeFile({term = 1, selection = "all"})<CR>', {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("n", "<Leader>mc", ':lua require("makefile_nvim.builtin").makeFile({term = 1, selection = "clean"})<CR>', {noremap = true, silent = true, expr = false})
```
