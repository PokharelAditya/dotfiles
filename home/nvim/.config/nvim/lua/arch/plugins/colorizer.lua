return {
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup(
        {
          "*";              -- Highlight all files
        },
        {
        names = true;       -- "Blue", "Red", etc
        RGB = true;         -- #RGB hex codes
        RRGGBB = true;      -- #RRGGBB hex codes
        RRGGBBAA = true;    -- #RRGGBBAA hex codes
        rgb_fn = true;      -- CSS rgb() / rgba() functions
        hsl_fn = true;      -- CSS hsl() / hsla() functions
        css = true;         -- Enable all CSS features: rgb_fn, hsl_fn, names
        css_fn = true;
        html = true;
      }, {
        mode = "background", -- or "foreground"
      })
    end,
  },
}
