vim.keymap.set("n", "<space>fd", vim.diagnostic.open_float, {})

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)

        vim.keymap.set("n", "gi", ":Telescope lsp_implementation", opts)
        vim.keymap.set("n", "<space>D", ":Telescope lsp_type_definitions", opts)
        vim.keymap.set("n", "gr", ":Telescope lsp_references <CR>", opts)
        vim.keymap.set("n", "<space>ll", ":LspRestart <CR>", opts)

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client.name ~= 'ts_ls' and client.name ~= 'eslint' and client.name ~= 'tailwindcss' and client.name ~= 'sourcekit' then
            vim.keymap.set("n", "<space>fm", function()
                vim.lsp.buf.format { async = true }
            end, opts)
        end
        vim.keymap.set("n", "<space>rn", function()
            vim.lsp.buf.rename()
        end, opts)
    end
})

local lsp = require("lspconfig")

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local servers = {
    'zls',
    'kotlin_language_server',
    'terraformls',
    'jsonls',
    'rust_analyzer',
    'nim_langserver',
    'eslint',
    'templ',
}

lsp.ts_ls.setup({
    capabilities = capabilities,
    on_attach = function()
        vim.keymap.set("n", "<space>fm", function()
            local cursor = vim.api.nvim_win_get_cursor(0)
            vim.cmd("silent !prettier --write %")
            cursor[1] = math.min(cursor[1], vim.api.nvim_buf_line_count(0))
            vim.api.nvim_win_set_cursor(0, cursor)
        end, {})
    end
})


for _, server in ipairs(servers) do
    lsp[server].setup({
        capabilities = capabilities,
    })
end

lsp.sourcekit.setup({
    capabilities = capabilities,
    cmd = { "xcrun", "--toolchain", "swift", "sourcekit-lsp" },
    on_attach = function()
        vim.keymap.set("n", "<space>fm", function()
            vim.cmd("silent !swift-format -i %")
        end, {})
    end
})
lsp.tailwindcss.setup({
    capabilities = capabilities,
    root_dir = lsp.util.root_pattern("go.mod", "package.json"),
    filetypes = { "html", "templ", "svelte" },
    single_file_support = true,
})

lsp.lua_ls.setup({
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            },
            workspace = {
                library = {
                    "${3rd}/love2d/library"
                }
            }
        }
    }
})

lsp.yamlls.setup({
    capabilities = capabilities,
    settings = {
        yaml = {
            schemas = {
                kubernetes = "*.yaml",
                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] =
                "*api*.{yml,yaml}",
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
                "*docker-compose*.{yml,yaml}",
                ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] =
                "*flow*.{yml,yaml}",
                ["http://json.schemastore.org/circleciconfig.json"] = ".circleci/*",
            }
        }
    }
})
