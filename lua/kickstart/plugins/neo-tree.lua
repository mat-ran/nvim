-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
    components = {
      harpoon_index = function(config, node, _)
        local Marked = require 'harpoon.mark'
        local path = node:get_id()
        local success, index = pcall(Marked.get_index_of, path)
        if success and index and index > 0 then
          return {
            text = string.format('%d ', index), -- <-- Add your favorite harpoon like arrow here
            highlight = config.highlight or 'NeoTreeDirectoryIcon',
          }
        else
          return {
            text = '  ',
          }
        end
      end,
    },
    renderers = {
      file = {
        { 'icon' },
        { 'name', use_git_status_colors = true },
        { 'harpoon_index' }, --> This is what actually adds the component in where you want it
        { 'diagnostics' },
        { 'git_status', highlight = 'NeoTreeDimText' },
      },
    },
    event_handlers = {
      {
        event = 'file_open_requested',
        handler = function()
          -- auto close
          -- vim.cmd 'Neotree close'
          -- OR
          require('neo-tree.command').execute { action = 'close' }
        end,
      },
    },
  },
}
