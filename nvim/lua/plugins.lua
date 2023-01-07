--- vim:textwidth=0:foldmethod=marker:foldlevel=1:
-------------------------------------------------------------------------------

vim.opt.runtimepath:append({ "c:\\bin\\home\\.local\\share\\nvim-data\\site\\pack\\packer\\opt\\mug.nvim" })
-- #Variables
vim.g.use_scheme = "mossco"
-- vim.g.did_load_filetypes = 1
-- vim.g.did_load_ftplugin = 1
local PACKER_DIR = vim.fn.stdpath("data") .. "\\site\\pack\\packer\\opt\\packer.nvim"
local packer_bootstrap

-- #AutoGroup
vim.api.nvim_create_augroup("rcPacker", {})

-- ##AutoCommands {{{2
if vim.fn.has("vim_starting") then
  vim.defer_fn(function()
    vim.api.nvim_command("doautocmd User LazyLoad")
  end, 100)

  vim.api.nvim_create_autocmd("User", {
    group = "rcPacker",
    pattern = "LazyLoad",
    once = true,
    callback = function()
      vim.g.loaded_matchit = nil
      require("config.lazyload")
      -- require("module.repository").get_branch_stats(vim.fn.getcwd())
    end,
  })
end

vim.api.nvim_create_autocmd("BufWritePost", {
  group = "rcPacker",
  pattern = "plugins.lua",
  command = "source <afile>|PackerCompile",
})

vim.api.nvim_create_autocmd("User", {
  group = "rcPacker",
  pattern = "PackerCompileDone",
  command = "echo 'PackerCompile Done'",
})
--}}}2

-- ##Packer install {{{2
if vim.fn.empty(vim.fn.glob(PACKER_DIR)) > 0 then
  packer_bootstrap =
    vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", PACKER_DIR })
end
--}}}2

-- #Plugins {{{1
vim.api.nvim_command([[packadd packer.nvim]])

return require("packer").startup({
  function(use)
    use({ "wbthomason/packer.nvim", opt = true })
    -- use({
    --   "j-hui/fidget.nvim",
    --   config = function()
    --     require("fidget").setup({
    --       window = {
    --         relative = "win", -- where to anchor, either "win" or "editor"
    --         blend = 0, -- &winblend for the window
    --         zindex = nil, -- the zindex value for the window
    --         border = "none", -- style of border for the fidget window
    --       },
    --     })
    --   end,
    --   event = "UIEnter",
    -- })
    use({
      "delphinus/cellwidths.nvim",
      config = function()
        require("cellwidths").setup({
          -- log_levet = "DEBUG",
          name = "user/custom",
          fallback = function(cw)
            cw.load("cica")
            cw.add({
              { 0xF000, 0xFD46, 2 },
            })
          end,
        })
      end,
      run = function()
        require("cellwidths").remove()
      end,
    })
    use({
      "c:/bin/repository/tar80/mug.nvim",
      setup = function()
        require("mug").setup({
          mkrepo = true,
          commit = true,
          diff = true,
          variables = {
            commit_notation = "conventional",
          },
        })
      end,
    })
    use({ "tar80/mossco.nvim", opt = true })
    use({
      "feline-nvim/feline.nvim",
      wants = "mossco.nvim",
      config = [[require("config.indicate")]],
      event = "UIEnter",
    })
    use({ "nvim-lua/plenary.nvim", module = "plenary" })
    use({ "williamboman/mason-lspconfig.nvim", module = "mason-lspconfig" })
    use({
      "williamboman/mason.nvim",
      opt = true,
      config = function()
        require("mason").setup({
          ui = {
            border = "single",
            icons = {
              package_installed = "🟢",
              package_pending = "🟠",
              package_uninstalled = "🔘",
            },
            keymaps = { apply_language_filter = "<NOP>" },
          },
          -- install_root_dir = path.concat { vim.fn.stdpath "data", "mason" },
          pip = { install_args = {} },
          -- log_level = vim.log.levels.INFO,
          -- max_concurrent_installers = 4,
          github = {},
        })
      end,
    })
    use({
      "jose-elias-alvarez/null-ls.nvim",
      opt = true,
    })
    use({
      "neovim/nvim-lspconfig",
      wants = { "mason.nvim", "null-ls.nvim", "cmp-nvim-lsp" },
      config = [[require("config.lsp")]],
      event = "UIEnter",
    })
    use({
      "nvim-treesitter/nvim-treesitter",
      module = "nvim-treesitter",
      run = ":TSUpdate",
      config = [[require('config.ts')]],
      event = "UIEnter",
    })
    use({
      "nvim-treesitter/nvim-treesitter-textobjects",
      config = [[require('config.ts_textobj')]],
      event = "User LazyLoad",
    })
    use({
      "nvim-telescope/telescope.nvim",
      tag = "0.1.0",
      wants = { "nvim-cmp", "vim-smartinput" },
      config = [[require('config.finder')]],
      cmd = { "Telescope" },
      keys = { { "n", "<Leader>" }, { "n", "gl" } },
    })
    -- use({
    --   "rcarriga/nvim-notify",
    --   event = "User LazyLoad",
    --   wants = { "telescope.nvim" },
    --   config = function()
    --     vim.notify = require("notify")
    --     require("notify").setup({
    --       fps = 30,
    --       level = 2,
    --       minimum_width = 50,
    --       timeout = 5000,
    --       render = "default",
    --       top_down = false,
    --       -- stages = "slide",
    --     })
    --   end,
    -- })
    use({ "kana/vim-smartword", event = "User LazyLoad" })
    use({ "tar80/nvim-select-multi-line", branch = "tar80", event = "User LazyLoad" })
    use({
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup({ ignore = "^$" })
      end,
      event = "User LazyLoad",
    })
    use({
      "vim-denops/denops.vim",
      requires = {
        { "yuki-yano/fuzzy-motion.vim", opt = true },
        { "vim-skk/skkeleton", opt = true },
      },
      wants = { "fuzzy-motion.vim", "skkeleton" },
      setup = function()
        vim.g.denops_disable_version_check = 1
      end,
      config = function()
        require("config.denos")
      end,
      event = { "User LazyLoad" },
    })
    use({
      "lewis6991/gitsigns.nvim",
      -- config = [[require('config.gits')]],
      event = { "CursorMoved" },
    })
    use({ "hrsh7th/vim-eft", event = "User LazyLoad" })
    use({
      "hrsh7th/nvim-cmp",
      modele = "cmp",
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        { "hrsh7th/vim-vsnip", after = "nvim-cmp" },
        { "hrsh7th/cmp-vsnip", after = "nvim-cmp" },
        { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
        { "hrsh7th/cmp-path", after = "nvim-cmp" },
        { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
        {
          "uga-rosa/cmp-dictionary",
          after = "nvim-cmp",
          config = function()
            require("cmp_dictionary").setup({
              dic = {
                ["javascript"] = { vim.g.repo .. "/myrepo/nvim/after/dict/ppx.dict" },
                ["PPxcfg"] = { vim.g.repo .. "/myrepo/nvim/after/dict/xcfg.dict" },
              },
              -- exact = 2,
              first_case_insensitive = true,
              document = false,
              max_items = -1,
              capacity = 5,
            })
            require("cmp_dictionary").update()
          end,
        },
        opt = 1,
      },
      config = function()
        require("config.completion")
      end,
      event = { "CursorMoved", "InsertEnter", "CmdlineEnter" },
    })
    use({ "kana/vim-operator-user", fn = "operator#user#define" })
    use({ "kana/vim-operator-replace", event = "User LazyLoad" })
    use({ "rhysd/vim-operator-surround", event = "CursorMoved" })
    use({
      "kana/vim-smartinput",
      config = function()
        require("config.input")
      end,
      event = { "InsertEnter", "CmdlineEnter" },
    })
    use({
      "tar80/vim-parenmatch",
      config = function()
        require("parenmatch").setup({
          highlight = { fg = "#D6B87B", underline = true },
          ignore_filetypes = { "TelescopePrompt", "cmp-menu", "help" },
          ignore_buftypes = { "nofile" },
          itmatch = {
            enable = true,
          },
        })
      end,
      event = "CursorMoved",
    })
    use({
      "uga-rosa/translate.nvim",
      cmd = { "Translate" },
    })
    use({
      "tversteeg/registers.nvim",
      config = function()
        local registers = require("registers")
        registers.setup({
          show_empty = false,
          register_user_command = false,
          system_clipboard = false,
          show_register_types = false,
          symbols = { tab = "~" },
          bind_keys = {
            registers = registers.apply_register({ delay = 0.1 }),
            normal = registers.show_window({
              mode = "motion",
              delay = 0.5,
            }),
            insert = registers.show_window({
              mode = "insert",
              delay = 0.5,
            }),
          },
          window = {
            max_width = 100,
            highlight_cursorline = true,
            border = "rounded",
            transparency = 9,
          },
        })
      end,
      keys = { { "n", '"' }, { "i", "<c-r>" } },
    })
    use({ "rhysd/conflict-marker.vim" })
    use({
      "cohama/agit.vim",
      setup = function()
        vim.g.agit_no_default_mappings = 0
        vim.g.agit_enable_auto_show_commit = 0
      end,
      cmd = { "Agit", "Agitfile" },
    })
    use({ "bfredl/nvim-luadev", cmd = "Luadev" })
    use({ "tyru/open-browser.vim", fn = "openbrowser#_keymap_smart_search" })
    use({
      "sindrets/diffview.nvim",
      cmd = { "DiffviewOpen", "DiffviewLog", "DiffviewFocusFiles", "DiffviewFileHistory" },
    })
    use({ "mbbill/undotree", fn = "undotree#UndotreeToggle" })
    use({ "norcalli/nvim-colorizer.lua", cmd = "Colorizer" })
    use({ "weilbith/nvim-code-action-menu", cmd = "CodeActionMenu" })
    use({ "vim-jp/vimdoc-ja" })
    use({ "tar80/vim-PPxcfg", ft = "cfg" })

    if packer_bootstrap then
      require("packer").sync()
    end
  end,
  config = {
    profile = {
      enable = true,
      threshold = 1,
    },
    display = {
      open_fn = require("packer.util").float,
    },
  },
})
