-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

-- #AutoGroup
-- vim.api.nvim_create_augroup("rcGits", {})

-- ##AutoCommands {{{2
-- vim.api.nvim_create_autocmd(
-- "BufEnter",
-- {
-- group = "rcGits",
-- pattern = "*",
-- callback = function()
-- if #vim.lsp.buf.list_workspace_folders() > 0 then
-- require("gitsigns").attach()
-- else
-- print(11111)
-- require("gitsigns").detach()
-- end
-- end
-- }
-- )

-- #GitSigns {{{1
require("gitsigns").setup({
  update_debounce = vim.g.update_time,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    -- Actions
    map({ "n", "v" }, "gsa", ":Gitsigns stage_hunk<CR>")
    map({ "n", "v" }, "gsu", ":Gitsigns reset_hunk<CR>")
    map("n", "gsA", gs.stage_buffer)
    map("n", "gsz", gs.undo_stage_hunk)
    map("n", "gsU", gs.reset_buffer)
    map("n", "gss", gs.preview_hunk)
    map("n", "gsb", function()
      gs.blame_line({ full = true })
    end)
    map("n", "gsv", gs.toggle_current_line_blame)

    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end,
})
--}}}1
