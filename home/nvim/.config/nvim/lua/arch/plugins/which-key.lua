return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,

  -- config = function()
  --   vim.cmd([[
  --     hi NormalFloat guibg=NONE ctermbg=NONE
  --     hi WhichKeyNormal guibg=NONE ctermbg=NONE
  --   ]])
  -- end,
}
