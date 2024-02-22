local config = {}

--主题
config.colorsscheme = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    vim.cmd([[colorscheme tokyonight]])
  end,
}


--状态栏
config.lualine =   {
  lazy = false,
  priority = 999,
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'tokyonight'
      }
    })
  end,
}

--文档树
config.neotree = {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim",              -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  keys = {
    { "<leader>ft", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
  },
  config = function()
    require("neo-tree").setup()
  end,
}

--跳转
config.navigator = {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  }
}

--语法高亮
config.treesitter= {
  "nvim-treesitter/nvim-treesitter",
  pin = true,
  event = "VeryLazy",
  config = function()
    require("nvim-treesitter.install").prefer_git = false
    require("nvim-treesitter.configs").setup({
      -- or use "all"
      ensure_installed ={ "vim","python","lua", "javascript", "json", "css", "markdown", "markdown_inline"},
      highlight = {
        enable = false,
        additional_vim_regex_highlighting = false
      },
      indent = {
        enable = true,
      },
      rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
      },
    })
  end,
}

--语法高亮下彩虹括号
config.bracket = {
  --括号颜色
  "p00f/nvim-ts-rainbow",
  lazy=false,
}

--lsp
config.lsp =   {
  --lsp
  "williamboman/mason.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })
    local registry = require "mason-registry"
    local function install(package)
      local s, p = pcall(registry.get_package, package)
      if s and not p:is_installed() then
        p:install()
      end
    end

    --use package
    local lsp_def_config = require "plugins.lsp"
    for _, v in pairs(lsp_def_config.ensure_installed) do
      install(v)
    end

    require("mason-lspconfig").setup {}
    local lspconfig = require("lspconfig")
    for _, v in pairs(lsp_def_config.servers) do
      if lspconfig[v] ~= nil then
        lspconfig[v].setup(lsp_def_config.language_setup())
      end
    end
  end,
}

--自动补全
config.cmp =   {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'l3mon4d3/luasnip',
    'saadparwaiz1/cmp_luasnip',
    'petertriho/cmp-git'
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local has_words_before = function ()
      unpack = unpack or table.unpack
      local line,col = unpack(vim.api.nvim_win_get_cursor(0))
      return col~=0 and vim.api.nvim_buf_get_lines(0,line-1,line,true)[1]:sub(col,col):match("%s")==nil
    end


    --wwy 使用变量指定引擎 
    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
            -- that way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
      }, {
        { name = 'buffer' },
      })
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'git' },
      }, {
        { name = 'buffer' },
      })
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
  end
}
--注释
config.comment = {
  --单行gcc注释 多行gc
  "numToStr/Comment.nvim",
  opts = {
    -- add any options here
  },
  lazy = false,
}

--括号匹配
config.autopairs=  {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {} -- this is equalent to setup({}) function
}

--顶部页签
config.bufferline =   {
  --顶部缓冲区
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  opts ={
    options = {
      -- 使用 nvim 内置lsp
      diagnostics = "nvim_lsp",
      -- 左侧让出 nvim-tree 的位置
      offsets = {{
        filetype = "neo-tree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "left"
      }}
    }
  },
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
    { "<a-y>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
    { "<a-p>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
  },
  config = function(_,opts)
    require("bufferline").setup(opts)
  end,
}
--git 相关信息
config.gitsigns = {
  "lewis6991/gitsigns.nvim"
}

--快速跳转
config.hop= {
  "smoka7/hop.nvim",
  opts = {
    --This is actually equal to:
    --require("hop.hint").HintPosition.END
    hint_position = 3,
    keys = "fjghdksltyrueiwoqpvbcnxmza",
  },
  keys = {
    {"<leader>hp",":HopWord<CR>",desc = "hop word",silent = true,noremap = true}
  }
}

--全局搜索
config.telescope=  {
  --全局搜索
  'nvim-telescope/telescope.nvim',
  tag = '0.1.5',
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  keys = {
    { "<leader>ff", ":Telescope find_files<CR>", desc = "find file", silent = true, noremap = true },
    { "<leader>fg", ":Telescope live_grep<CR>",  desc = "live grep", silent = true, noremap = true },
    { "<leader>fb", ":Telescope buffers<CR>",    desc = "buffers",   silent = true, noremap = true },
    { "<leader>fh", ":Telescope help_tags<CR>",  desc = "help_tags", silent = true, noremap = true },
  },
}
--按键提示
config.keytip  = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
}


local needLoadconfig = {
  'colorsscheme','lualine',
  'neotree','navigator',
  'lsp','cmp',  'autopairs','gitsigns',
  'hop','keytip','comment',
  'telescope','bufferline','treesitter',
  'bracket'
}

Noah.plugins = {}
for _,name in pairs(needLoadconfig) do
  Noah.plugins[#Noah.plugins+1] = config[name]
end
