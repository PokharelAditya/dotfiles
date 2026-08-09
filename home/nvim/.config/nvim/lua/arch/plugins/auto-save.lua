return {
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },
        defer_save = { "InsertLeave", "TextChanged" },
        cancel_deferred_save = { "InsertEnter" }, -- fixed spelling
      },
      condition = nil,
      write_all_buffers = false,
      noautocmd = false,
      lockmarks = false,
      debounce_delay = 1000,
      debug = false,
    },
    config = function(_, opts)
      require("auto-save").setup(opts)

      -- optional: add save message
      vim.api.nvim_create_autocmd("User", {
        pattern = "AutoSaveWritePost",
        callback = function()
          vim.notify("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
        end,
      })
    end,
  },
}
