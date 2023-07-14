local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    name = "prettier",
    args = { "--print-width=200", "--tab-width=2", "--single-quote" },
    filetypes = { "javascript" }
  }
}

lvim.format_on_save.enabled = true

lvim.plugins = {
  { "mg979/vim-visual-multi" },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      vim.g.gitblame_enabled = 1
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
}
