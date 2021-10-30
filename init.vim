call plug#begin('~/AppData/Local/nvim/plugged')
 Plug 'tomasiser/vim-code-dark'
 Plug 'pangloss/vim-javascript'
 Plug 'itchyny/lightline.vim'
 Plug 'itchyny/vim-gitbranch'
 Plug 'szw/vim-maximizer'
 Plug 'christoomey/vim-tmux-navigator'
 Plug 'kassio/neoterm'
 Plug 'tpope/vim-commentary'
 Plug 'sbdchd/neoformat'
 Plug 'junegunn/fzf',{ 'dir': '~/.fzf', 'do': './install --all'}
 Plug 'junegunn/fzf.vim'
 Plug 'tpope/vim-fugitive'
 Plug 'airblade/vim-gitgutter'
 Plug 'neovim/nvim-lspconfig'
 Plug 'nvim-lua/completion-nvim'
 Plug 'Chiel92/vim-autoformat'

call plug#end()

" default options 

set completeopt=menuone,noinsert,noselect 
set mouse =a
set splitright 
set splitbelow 
set expandtab 
set tabstop=2 
set shiftwidth=2 
set number 
set ignorecase 
set smartcase 
set incsearch
set diffopt+=vertical " starts diff mode in vertical split 
set hidden 
set cmdheight=1
set shortmess+=c " don't need to press enter so often 
set signcolumn=yes 
set updatetime=750
filetype plugin indent on
set undofile " persists undo tree 
let mapleader = " " 
if (has("termguicolors"))   
              set termguicolors 
endif 
let g:netrw_banner=0 " disable banner in netrw 
let g:markdown_fenced_languages = ['javascript', 'js=javascript', 'json=javascript'] " syntax highlighting in markdown 
nnoremap <leader>v :e $MYVIMRC<CR>

colorscheme codedark 

let g:lightline = {
         \ 'active': {
         \  'left': [ [ 'mode' , 'paste'],
         \            [ 'gitbranch', 'readonly', 'filename', 'modified'] ]
         \  },
         \ 'component_function': {
         \    'gitbranch':'gitbranch#name'
         \  },
         \  'colorscheme':'codedark',
         \ }


nnoremap <leader>m :MaximizerToggle!<CR>


let g:neoterm_default_mod = 'vertical'
let g:neoterm_size = 60
let g:neoterm_autoinsert = 1

nnoremap <c-q> :Ttoggle<CR>
inoremap <c-q> <Esc>:Ttoggle<CR>
tnoremap <c-q> <c-\><c-n>:Ttoggle<CR>
nnoremap <leader>F :Neoformat prettier<CR>


nnoremap <leader><space> :GFiles<CR>
nnoremap <leader>ff :Rg<CR>
inoremap <expr> <c-x><c-f> fzf#vim#complete#path(
      \ "find . -path '*/\.*' -prune -o -print \| sed '1d;s:^..::'",
      \  fzf#wrap({ 'dir': expand('%:p:h')}))
if has('nvim')
    au! TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    au! FileType fzf tunmap <buffer> <Esc>
endif

nnoremap <leader>gg :G<cr>

lua require'lspconfig'.tsserver.setup{ on_attach=require'completion'.on_attach }

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gh    <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gH    <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gR    <cmd>lua vim.lsp.buf.rename()<CR> 

# let g:completion_enable_snippet = 'vim-vsnip'

lua << EOF
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }
  
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  end

 -- map buffer local keybindings when the language server attaches
  local servers = { 'pyright', 'rust_analyzer', 'tsserver' }
  for _, lsp in ipairs(servers) do

     nvim_lsp[lsp].setup {
         on_attach = on_attach,
         flags = {
              debounce_text_changes = 150,
      }
    }
  end
  EOF
