return {
  {
    'yuki-yano/fuzzy-motion.vim',
    event = 'VeryLazy',
    init = function()
      vim.g.fuzzy_motion_labels = { 'A', 'S', 'D', 'F', 'G', 'W', 'E', 'R', 'Z', 'X', 'C', 'V', 'B', 'T', 'Q' }
      -- vim.g.fuzzy_motion_word_filter_regexp_list = { '^[a-zA-Z0-9]' }
      -- vim.g.fuzzy_motion_word_regexp_list = [ '[0-9a-zA-Z_-]+', '([0-9a-zA-Z_-]|[.])+', '([0-9a-zA-Z_-]|[().#])+' ]
      -- vim.g.fuzzy_motion_auto_jump = false
    end,
    config = function()
      -- vim.g.fuzzy_motion_matchers = { 'fzf', 'kensaku' }
      vim.keymap.set('n', '<Leader><leader>', function()
        if vim.fn['denops#plugin#is_loaded']('fuzzy-motion') == 0 then
          vim.fn['denops#plugin#load']('fuzzy-motion')
        end
        local matchers = { 'fzf' }
        if vim.fn['denops#plugin#is_loaded']('kensaku') == 1 then
          table.insert(matchers, 'kensaku')
        end
        vim.g.fuzzy_motion_matchers = matchers
        vim.cmd.FuzzyMotion()
      end, { desc = 'Fuzzy Motion' })
    end,
  },
}
