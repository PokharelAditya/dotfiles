vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("x", "d", '"_x', { desc = "Delete selection" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<leader>nn", "<cmd>NoiceDismiss<CR>", { desc = "Clear noice notifications" })
keymap.set("n", "<leader>nw", function()
  vim.wo.wrap = not vim.wo.wrap
  vim.wo.linebreak = vim.wo.wrap
  vim.wo.breakindent = vim.wo.wrap
end, { desc = "Toggle line wrap" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sx", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sq", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tq", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tb", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- buffer management
keymap.set("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Open last buffer" })
keymap.set("n", "<leader>bt", "<cmd>tab sb#<cr>", { desc = "Open last buffer in new tab" })
keymap.set("n", "<leader>bx", "<cmd>sb#<cr>", { desc = "Open last buffer in horizontal split" })
keymap.set("n", "<leader>bv", "<cmd>vert sb#<cr>", { desc = "Open last buffer in vertical split" })
keymap.set("n", "<leader>bq", "<cmd>bd<cr>", { desc = "Delete current buffer" })
keymap.set("n", "<leader>bd", "<cmd>bufdo bd<cr>", { desc = "Delete all buffers" })
keymap.set("n", "<leader>br", "<cmd>e<cr>", { desc = "Refresh current buffer" })
keymap.set("n", "<leader>bs", "<cmd>w<cr>", { desc = "Save current buffer" })
keymap.set("n", "<leader>bS", "<cmd>SudaWrite<cr>", { desc = "Save current buffer as superuser" })

-- terminal management
keymap.set("n", "<leader>zz", "<cmd>terminal<CR><cmd>startinsert<CR>", { desc = "Open terminal" })
keymap.set("n", "<leader>zx", "<cmd>split | terminal<CR><cmd>startinsert<CR>", { desc = "Open terminal in horizontal split" })
keymap.set("n", "<leader>zv", "<cmd>vsplit | terminal<CR><cmd>startinsert<CR>", { desc = "Open terminal in vertical split" })
keymap.set("n", "<leader>zt", "<cmd>tabnew | terminal<CR><cmd>startinsert<CR>", { desc = "Open terminal in new tab" })
keymap.set("t", "<C-n>", [[<C-\><C-n>]], { desc = "Normal mode" })


keymap.set("n", "<leader>q", "<cmd>qa<CR>", { desc = "Quit Neovim" })
