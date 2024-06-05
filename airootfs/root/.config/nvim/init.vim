lua << EOF
vim.g.mapleader = ";"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({

{ 'echasnovski/mini.files', version = false }, --file explorer
{ 'echasnovski/mini.indentscope', version = '*' }, --scop visualier
 --"zbirenbaum/copilot.lua" , -- github copilot
 "github/copilot.vim",
 "nvim-treesitter/nvim-treesitter" , --syntax hightlight 
 'simrat39/symbols-outline.nvim', -- code outline
 "NvChad/nvim-colorizer.lua" , --color preview
 -- Language server and auto completion plugins
 "neovim/nvim-lspconfig" , -- built-in LSP
 "williamboman/mason.nvim" , --Easily install and manage LSP servers, DAP servers, linters, and formatters.
 "williamboman/mason-lspconfig.nvim" , --LSP installer
--  "williamboman/nvim-lsp-installer" , -- language server auto installer
 "hrsh7th/cmp-nvim-lsp" , --auto completion suite
 "hrsh7th/cmp-buffer",
 "hrsh7th/cmp-path",
 "hrsh7th/cmp-cmdline",
 "hrsh7th/cmp-vsnip",
 "hrsh7th/vim-vsnip",
 "SirVer/ultisnips",
 "quangnguyen30192/cmp-nvim-ultisnips",
 "dcampos/nvim-snippy",
 "dcampos/cmp-snippy",
 "hrsh7th/nvim-cmp",
 "onsails/lspkind-nvim" , --auto completion icons
 "rcarriga/nvim-notify" , -- notification
-- "ms-jpq/coq_nvim",  --auto completion tool
-- "ms-jpq/coq.artifacts", -- 9000+ snippet
 "weilbith/nvim-code-action-menu" , --codeaction menu
 "tpope/vim-sleuth" , --auto indent space detector
 "mfussenegger/nvim-dap" , --debugging support 
 "rcarriga/nvim-dap-ui" , --nvim-dap ui support
 "theHamsta/nvim-dap-virtual-text",
 "terrortylor/nvim-comment" , -- comment toggler
 "APZelos/blamer.nvim" , -- git blame
 "vim-airline/vim-airline" , --status bar
 "lukas-reineke/indent-blankline.nvim" , --indent indicator
 "nvim-tree/nvim-web-devicons" , --colored icons
 "akinsho/bufferline.nvim" , --visual studio code styles tabs
 "ryanoasis/vim-devicons" , --icons
 "kyazdani42/nvim-tree.lua" , -- file explorer

 "nvim-lua/plenary.nvim" , -- don"t know what this it but needed for telescope
 "nvim-telescope/telescope.nvim" , -- fuzzy finder
 -- active window expander
 "anuvyklack/windows.nvim" ,
 "anuvyklack/middleclass",
 "anuvyklack/animation.nvim",
 "BlackLight/nvim-http",
  {
      'goolord/alpha-nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function ()
          require'alpha'.setup(require'alpha.themes.startify'.config)
      end
  }
})

EOF

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set mouse=n "disable mouse
set clipboard+=unnamedplus
set path+=**                                    " Searches current directory recursively.
set updatetime=100
set hidden                      " Needed to keep multiple buffers open
set nobackup                    " No auto backups
set noswapfile                  " No swap
set number                      " line numbers
set relativenumber
set completeopt=menu,menuone,noselect
set laststatus=3                " global status bar
let mapleader=";"


set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" Spaces & Tabs {{{
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " tabs are space
set autoindent
set copyindent      " copy indent from the previous line
" }}} Spaces & Tabs

" line swap keybindings
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-k> :m '<-2<CR>gv=gv 
vnoremap <A-j> :m '>+1<CR>gv=gv

" escape
inoremap <C-c> <Esc>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Splits and Tabbed Files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set splitbelow
" Make adjusing split sizes a bit more friendly
noremap <silent> <C-a> :vertical resize +3<CR>
noremap <silent> <C-d> :vertical resize -3<CR>
" noremap <silent> <C-w> :resize +3<CR>
" noremap <silent> <C-s> :resize -3<CR>

"treesitter (syntax hightlight) and color scheme configs 
" au BufNewFile,BufRead *.sol setfiletype solidity


noremap <silent> <leader>e :lua MiniFiles.open() <CR>
lua << EOF
require('mini.files').setup()
require('mini.indentscope').setup()
EOF

lua << EOF
    vim.notify = require("notify")
    vim.notify.setup(
      {
        fps = 5,
        render = "default",
        stages = "slide",
        timeout = 3000,
      }
    );
  require'windows'.setup({
    autowidth = {			--		       |windows.autowidth|
        winwidth = 1.4,			--		        |windows.winwidth|
       },
  })
    require'colorizer'.setup()

  require'nvim-treesitter.configs'.setup {
    -- ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    autotag = {enable = true},
    highlight = {
      enable = true,              -- false will disable the whole extension
      disable = function(lang, bufnr) 
        return vim.api.nvim_buf_line_count(bufnr) > 10000
      end,
    },
  }  

EOF

" convert to lua copilot
set termguicolors 
syntax on
colorscheme default
highlight Normal guibg=#00003f
highlight Pmenu guibg=#0300b3 guifg=#00FFFF
highlight PmenuSel guibg=#00FFFF guifg=#000000
highlight CursorLineNr guifg=#ffffff guibg=NONE
highlight LineNr guibg=NONE guifg=#a6a4a4
highlight WinSeparator guifg=#ffffff
highlight SignColumn guibg=NONE
highlight NonText guibg=none
""""""""""""""""""""
" git blame
""""""""""""""""""""
let g:blamer_enabled = 1
let g:blamer_relative_time = 1

"""""""""""""""""""""
" setup comment toggler
lua require('nvim_comment').setup()

" setup telescope
lua require('telescope').setup()
noremap <silent> <leader>lg :Telescope live_grep <CR>
noremap <silent> <leader>bf :Telescope current_buffer_fuzzy_find <CR>
noremap <silent> <leader>pf :Telescope find_files <CR>

" airline (status bar) git branch display
let g:airline#extensions#branch#enabled = 1

" built in LSP keybindings and auto completion setup
" Turn this block into lua copilot
 " nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
 " nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
 " nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
 " nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
 " nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
 " nnoremap <silent> <F2> <cmd>lua vim.lsp.buf.rename()<CR>
 " nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_hlp()<CR>
 " nnoremap <silent> <C-n> <cmd>lua vim.diagnostic.goto_next()<CR>
 " nnoremap <silent> <C-p> <cmd>lua vim.diagnostic.goto_prev()<CR>
 " nnoremap <silent> ca <cmd> :CodeActionMenu <CR>
""

lua << EOF
local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}
keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
--rename or replace rn
keymap('n', 'Rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
keymap('n', '<C-n>', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)
keymap('n', '<C-p>', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
keymap('n', 'ca', '<Cmd>:CodeActionMenu<CR>', opts)
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
EOF

" coq and mason LSP STUFF
lua << EOF
require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = {
      'tsserver', 
      'cssls',
      'vimls',
      'clangd',
      'pyright',
      'pylsp',
      'omnisharp_mono',
      'rust_analyzer',
      'jdtls',
      'gopls',
    }
})
-- local lsp = require "lspconfig"
-- local coq = require "coq" 
-- lsp.tsserver.setup(coq.lsp_ensure_capabilities())
-- vim.cmd('COQnow -s')
EOF

"vscode style tabs (bufferline plugin) setup 
nnoremap <silent> <A-n> :BufferLineCycleNext <CR>
nnoremap <silent> <A-p> :BufferLineCyclePrev <CR>
lua << EOF
require("bufferline").setup{
  options = {
      numbers = function(opts)
        return string.format('%s.%s', opts.id, opts.raise(opts.ordinal))
      end,
    show_buffer_close_icons = true,
    show_close_icon = true,
    tabsize = 25,
    offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    highlight = "Directory",
                    text_align = "center"
                }
                },
    diagnostics = "nvim_lsp"
  }
}
require("symbols-outline").setup()


EOF

source ~/.config/nvim/debugger.lua
source ~/.config/nvim/nvimCmp.lua
source ~/.config/nvim/splash.lua
