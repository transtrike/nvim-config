local M = {
  -- LSP
  {
    'williamboman/mason.nvim',
    opts = {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗'
        }
      },
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 4,
    },
    keys = {
        { 'gd', vim.lsp.buf.definition, 'n', desc = 'Goto Definition' },
        { 'gD', vim.lsp.buf.declaration, 'n', desc = 'Goto Declaration' },
        { 'gr', require('telescope.builtin').lsp_references, 'n', desc = 'Goto References' },
        { 'gI', vim.lsp.buf.implementation, 'n', desc = 'Goto Implementation' },

        { '<leader>sr', vim.lsp.buf.rename, 'n', desc = 'Rename' },

        { '<leader>ca', vim.lsp.buf.code_action, 'n', desc = 'Code Action' },
        { '<leader>ct', vim.lsp.buf.type_definition, 'n', desc = 'Code Type Definition' },
        { '<leader>cs', require('telescope.builtin').lsp_document_symbols, 'n', desc = 'Code Symbols' },
        { '<leader>cf', vim.lsp.buf.format, 'n', desc = 'Code Format' },
        { 'K', vim.lsp.buf.hover, 'n', desc = 'Hover Documentation' },
        { '<C-k>', vim.lsp.buf.signature_help, 'n', desc = 'Signature Documentation' }, 
    }
  },

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    opts = {},
  },

  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'j-hui/fidget.nvim',
      'folke/neodev.nvim',
      'hrsh7th/cmp-nvim-lsp'
    },
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
          -- prefix = "icons",
        },
        severity_sort = true,
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      inlay_hints = {
        enabled = false,
      },
      -- add any global capabilities here
      capabilities = {},
      -- Automatically format on save
      autoformat = true,
      -- Enable this to show formatters used in a notification
      -- Useful for debugging formatter issues
      format_notify = false,
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectory = { mode = 'auto' },
          },
        },
        jsonls = {},
        lua_ls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          -- Use this to add any additional keymaps
          -- for specific lsp servers
          ---@type LazyKeys[]
          -- keys = {},
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    --@param opts PluginLspOpts
    config = function(_, opts)
    end,
    ---@param opts PluginLspOpts
    -- config = function(_, opts)
    --   local Util = require("util")
    --
    --   if Util.has("neoconf.nvim") then
    --     local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
    --     require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
    --   end
    --   -- setup autoformat
    --   require("lazyvim.plugins.lsp.format").setup(opts)
    --   -- setup formatting and keymaps
    --   Util.on_attach(function(client, buffer)
    --     require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
    --   end)
    --
    --   local register_capability = vim.lsp.handlers["client/registerCapability"]
    --
    --   vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
    --     local ret = register_capability(err, res, ctx)
    --     local client_id = ctx.client_id
    --     ---@type lsp.Client
    --     local client = vim.lsp.get_client_by_id(client_id)
    --     local buffer = vim.api.nvim_get_current_buf()
    --     require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
    --     return ret
    --   end
    --
    --   -- diagnostics
    --   for name, icon in pairs(require("lazyvim.config").icons.diagnostics) do
    --     name = "DiagnosticSign" .. name
    --     vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
    --   end
    --
    --   local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
    --
    --   if opts.inlay_hints.enabled and inlay_hint then
    --     Util.on_attach(function(client, buffer)
    --       if client.supports_method('textDocument/inlayHint') then
    --         inlay_hint(buffer, true)
    --       end
    --     end)
    --   end
    --
    --   if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
    --     opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
    --         or function(diagnostic)
    --           local icons = require("lazyvim.config").icons.diagnostics
    --           for d, icon in pairs(icons) do
    --             if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
    --               return icon
    --             end
    --           end
    --         end
    --   end
    --
    --   vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
    --
    --   local servers = opts.servers
    --   local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    --   local capabilities = vim.tbl_deep_extend(
    --     "force",
    --     {},
    --     vim.lsp.protocol.make_client_capabilities(),
    --     has_cmp and cmp_nvim_lsp.default_capabilities() or {},
    --     opts.capabilities or {}
    --   )
    --
    --   local function setup(server)
    --     local server_opts = vim.tbl_deep_extend("force", {
    --       capabilities = vim.deepcopy(capabilities),
    --     }, servers[server] or {})
    --
    --     if opts.setup[server] then
    --       if opts.setup[server](server, server_opts) then
    --         return
    --       end
    --     elseif opts.setup["*"] then
    --       if opts.setup["*"](server, server_opts) then
    --         return
    --       end
    --     end
    --     require("lspconfig")[server].setup(server_opts)
    --   end
    --
    --   -- get all the servers that are available through mason-lspconfig
    --   local have_mason, mlsp = pcall(require, "mason-lspconfig")
    --   local all_mslp_servers = {}
    --   if have_mason then
    --     all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
    --   end
    --
    --   local ensure_installed = {} ---@type string[]
    --   for server, server_opts in pairs(servers) do
    --     if server_opts then
    --       server_opts = server_opts == true and {} or server_opts
    --       -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
    --       if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
    --         setup(server)
    --       else
    --         ensure_installed[#ensure_installed + 1] = server
    --       end
    --     end
    --   end
    --
    --   if have_mason then
    --     mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
    --   end
    --
    --   if Util.lsp_get_config("denols") and Util.lsp_get_config("tsserver") then
    --     local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
    --     Util.lsp_disable("tsserver", is_deno)
    --     Util.lsp_disable("denols", function(root_dir)
    --       return not is_deno(root_dir)
    --     end)
    --   end
    -- end,
  },

  -- mason-nvim-dap.nvim closes some gaps that exist between mason.nvim and nvim-dap. Its main responsibilities are:
  -- 1. provide extra convenience APIs such as the :DapInstall command
  -- 2. allow you to (i) automatically install, and (ii) automatically set up a predefined list of adapters
  -- 3. translate between dap adapter names and mason.nvim package names (e.g. python <-> debugpy)
  {
    'jay-babu/mason-nvim-dap.nvim',
    event = 'VeryLazy',
    dependencies = {
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap',
    },
    opts = {
      automatic_setup = true,
    }
  },

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
    },
    opts = {
      automatic_installation = true,
      ensure_installed = { 'rust_analyzer', 'lua_ls' },
      handlers = {
        function(server_name)
          require('lspconfig')[server_name].setup {}
        end,

        --['rust_analyzer'] = function()
        --  require('rust-tools').setup {}
        --end,

        ['lua_ls'] = function()
          require('lspconfig').lua_ls.setup {
            settings = {
              Lua = {
                diagnostics = {
                  globals = { 'vim' }
                }
              }
            }
          }
        end,
      },
    },
  },

  --{
    --'VonHeikemen/lsp-zero.nvim',
    --branch = 'v3.x',
    --dependencies = {
      ---- LSP Support
      --{'neovim/nvim-lspconfig'},
      --{'williamboman/mason.nvim'},
      --{'williamboman/mason-lspconfig.nvim'},
      ---- Autocompletion
      --{'hrsh7th/nvim-cmp'},
      --{'hrsh7th/cmp-nvim-lsp'},
      --{'L3MON4D3/LuaSnip'},
    --},
    --opts = {},
    --config = {},
  --},

  -- Import Languages's configs
  { import = 'modules.lsp.languages.lua' },
};

return M;
