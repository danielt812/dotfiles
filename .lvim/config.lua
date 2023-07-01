local o = vim.opt
o.hlsearch = true
o.number = true
o.relativenumber = false
o.shiftwidth = 2
o.showmode = true
o.smartindent = true
o.smarttab = true
o.splitbelow = true
o.splitbelow = true
o.swapfile = false
o.tabstop = 2
o.writebackup = false
o.expandtab = true
o.wrap = false

lvim.builtin.nvimtree.setup.filters.dotfiles = true

lvim.format_on_save.enabled = true

lvim.plugins = {
  { "mg979/vim-visual-multi" },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      vim.g.gitblame_enabled = 0
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
}
