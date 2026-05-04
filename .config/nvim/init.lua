-- -----------------------------------------------------------------------------
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- -----------------------------------------------------------------------------
-- plugins

require("lazy").setup({
  -- lsp
  {
    "neovim/nvim-lspconfig",
  },

  -- completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },

  -- display
  "lukas-reineke/indent-blankline.nvim",
  "nvim-lualine/lualine.nvim",

  -- explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- git
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",

  -- telescope
  "nvim-lua/plenary.nvim",
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  "hashivim/vim-terraform",
  "vim-ruby/vim-ruby",
  "tpope/vim-rails",
  "chr4/nginx.vim",
  "itkq/fluentd-vim",
  "elzr/vim-json",
  "google/vim-jsonnet",
  "jparise/vim-graphql",
  "glidenote/memolist.vim",
})

-- -----------------------------------------------------------------------------
-- basic options

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.scrolloff = 5
vim.opt.textwidth = 0
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.hidden = true
vim.opt.visualbell = true
vim.opt.whichwrap = "b,s,h,l,<,>,[,]"
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.number = true
vim.opt.list = true
vim.opt.listchars = {
  tab = "¦ ",
  trail = "_",
  extends = ">",
  precedes = "<",
}
vim.opt.display = "uhex"
vim.opt.visualbell = false
vim.opt.clipboard = "unnamed"
vim.opt.showtabline = 2
vim.opt.synmaxcol = 300
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.history = 1000
vim.opt.complete:append("k")
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.fileformats = "unix,dos"

-- -----------------------------------------------------------------------------
-- nvim tree
require("nvim-tree").setup({
  view = {
    width = 35,
  },
  filters = {
    dotfiles = false,
  },
})

vim.keymap.set(
  "n",
  "<C-e>",
  "<cmd>NvimTreeToggle<CR>",
  { silent = true }
)

-- -----------------------------------------------------------------------------
-- LSP

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("solargraph", {
  cmd = { "solargraph", "stdio" },
  capabilities = capabilities,
  settings = {
    solargraph = {
      diagnostics = false,
    },
  },
})

vim.lsp.config("terraformls", {
  cmd = { "terraform-ls", "serve" },
  capabilities = capabilities,
})

vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  capabilities = capabilities,
})

vim.lsp.enable({
  "solargraph",
  "terraformls",
  "ts_ls",
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})

-- -----------------------------------------------------------------------------
-- completion

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  window = {
    documentation = cmp.config.disable,
  },

  -- 以下は今の設定のまま
  enabled = true,

  completion = {
    autocomplete = {
      cmp.TriggerEvent.TextChanged,
    },
    completeopt = "menu,menuone,noinsert",
  },

  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp", keyword_length = 1 },
    { name = "buffer", keyword_length = 2 },
    { name = "path" },
  }),
})

-- -----------------------------------------------------------------------------
-- etc

vim.g.terraform_fmt_on_save = 0
vim.g.vim_json_syntax_conceal = 0

-- -----------------------------------------------------------------------------
-- invisible full-width space highlight

vim.cmd([[
if has("syntax")
  syntax on

  function! ActivateInvisibleIndicator()
    syntax match InvisibleJISX0208Space "　" display containedin=ALL
    highlight InvisibleJISX0208Space term=underline ctermbg=Cyan guibg=Cyan
  endf

  augroup invisible
    autocmd! invisible
    autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
  augroup END
endif
]])

-- -----------------------------------------------------------------------------
-- indent

local indent_group = vim.api.nvim_create_augroup("my-indent", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = {
    "ruby",
    "html",
    "eruby",
    "yaml",
    "yml",
    "typescript",
    "javascript",
    "markdown",
  },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- -----------------------------------------------------------------------------
-- filetype

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.md",
  command = "set filetype=markdown",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.psgi", "*.t", "cpanfile" },
  command = "set filetype=perl",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  command = "hi! def link markdownItalic Normal",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "markdown" },
  command = "setlocal conceallevel=0",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.dig",
  command = "set filetype=yaml",
})

vim.api.nvim_create_autocmd("Syntax", {
  pattern = "yaml",
  command = "setlocal indentkeys-=<:> indentkeys-=0#",
})

-- -----------------------------------------------------------------------------
-- keymaps

vim.keymap.set("n", "<Space>.", ":<C-u>edit $MYVIMRC<CR>", { silent = true })
vim.keymap.set("n", "<Space>,", ":<C-u>source $MYVIMRC<CR>", { silent = true })
vim.keymap.set("n", "g/", ":%s/<C-R><C-w>//gc<Left><Left><Left>", { silent = false })
vim.keymap.set("", "<Esc><Esc>", ":nohlsearch<CR><Esc>", { silent = true })
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "<C-n>", ":tabe<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", ":tabn<CR>", { silent = true })
vim.keymap.set("n", "<C-h>", ":tabN<CR>", { silent = true })

vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")
vim.keymap.set("n", "g*", "g*zz")
vim.keymap.set("n", "g#", "g#zz")
vim.keymap.set("n", "G", "Gzz")

vim.keymap.set("i", "<C-j>", "<C-[>")

-- Telescope
vim.keymap.set("n", "<D-p>", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<D-F>", "<cmd>Telescope live_grep<CR>")
vim.keymap.set("n", "fb", "<cmd>Telescope buffers<CR>")
vim.keymap.set("n", "fh", "<cmd>Telescope help_tags<CR>")

-- -----------------------------------------------------------------------------
-- lualine / telescope / indent-blankline

require("lualine").setup()

local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    file_ignore_patterns = { "^node_modules/" },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
})

pcall(function()
  require("telescope").load_extension("fzf")
end)

require("ibl").setup()

-- -----------------------------------------------------------------------------
-- memolist

vim.g.memolist_path = "~/.memolist/01_zatsu"
vim.g.memolist_memo_suffix = "md"
vim.g.memolist_template_dir_path = "~/.memolist/99_template"

vim.keymap.set("n", "<Space>m", ":MemoNew<CR>", { silent = true })


vim.keymap.set("n", "<leader>gh", "<cmd>GBrowse<CR>", { silent = true })
vim.keymap.set("v", "<leader>gh", ":GBrowse<CR>", { silent = true })
