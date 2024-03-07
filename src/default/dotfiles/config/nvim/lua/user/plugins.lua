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
    "nvim-tree/nvim-web-devicons",
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            vim.cmd "colorscheme catppuccin"
        end
    },
    "xiyaowong/transparent.nvim",
    {
        "nvim-treesitter/nvim-treesitter",
        build = function(_)
            vim.cmd("TSUpdate")
        end,
        config = function()
            require("nvim-treesitter.configs").setup {
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                ensure_installed = {
                    "bash",
                    "dockerfile",
                    "fish",
                    "gitcommit",
                    "gitignore",
                    "java",
                    "json",
                    "kotlin",
                    "lua",
                    "rust",
                    "sql",
                    "terraform",
                    "toml",
                    "tsx",
                    "typescript",
                    "vim",
                    "yaml",
                    "html",
                }
            }
        end
    },
    {
        "m-demare/hlargs.nvim",
        config = function()
            require('hlargs').setup({
                disable = function(_, bufnr)
                    if vim.b.semantic_tokens then
                        return true
                    end
                    local clients = vim.lsp.get_active_clients { bufnr = bufnr }
                    for _, c in pairs(clients) do
                        local caps = c.server_capabilities
                        if c.name ~= "null-ls" and caps.semanticTokensProvider and caps.semanticTokensProvider.full then
                            vim.b.semantic_tokens = true
                            return vim.b.semantic_tokens
                        end
                    end
                end,
            })
        end
    },
    "leafgarland/typescript-vim",
    {
        "https://github.com/apple/pkl-neovim",
        lazy = true,
        event = "BufReadPre *.pkl",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        build = function()
            vim.cmd("TSInstall! pkl")
        end,
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require('colorizer').setup()
        end
    },
    {
        "junegunn/fzf.vim",
        dependencies = {
            "junegunn/fzf",
            name = "fzf",
            build = "./install --all",
        }
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end
    },
    {
        "mfussenegger/nvim-dap",
    },

    "f-person/git-blame.nvim",
    "kdheepak/lazygit.nvim",
    "tpope/vim-commentary",
    {
        "ldelossa/gh.nvim",
        dependencies = {
            "ldelossa/litee.nvim",
        },
        config = function()
            require('litee.lib').setup()
            require('litee.gh').setup()
        end
    },

    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup()
        end,

    },
    "jose-elias-alvarez/null-ls.nvim",
    "RishabhRD/nvim-lsputils",
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            {
                'williamboman/mason.nvim',
                opts = {
                    ensure_installed = {
                        "js-debug-adapter",
                    }
                },
            },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        },
        config = function()

        end
    },
    {
        "evanleck/vim-svelte",
        dependencies = {
            "othree/html5.vim",
            "pangloss/vim-javascript"
        }
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.prettierd,
                },
            })
        end,
    },
    { "simrat39/rust-tools.nvim" },
    {
        "ziglang/zig.vim",
        config = function()
            vim.g.zig_fmt_autosave = 0
        end
    },
    "mbbill/undotree",
    "tpope/vim-surround",
    {
        "Pocco81/auto-save.nvim",
        config = function()
            require("auto-save").setup()
        end
    },
}, {})
