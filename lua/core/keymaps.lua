vim.g.mapleader=" "
-- vim.g.maplocalleader=" "

local keymap = vim.keymap

-----------插入模式-------------
keymap.set("i","jk","<ESC>")


-----------视觉模式-------------
--单行或多行移动
keymap.set("v","J",":m '>+1<CR>gv=gv")
keymap.set("v","K",":m '>-2<CR>gv=gv")

-----------正常模式-------------
--窗口
--水平
keymap.set("n","<leader>sh","<C-w>v")
--垂直
keymap.set("n","<leader>sv","<C-w>s")

--取消高亮
keymap.set("n","<leader>nh",":noh<CR>")

keymap.set("n","j","v:count == 0 ? 'gj' : 'j'",{expr=true})
keymap.set("n","k","v:count == 0 ? 'gk' : 'k'",{expr=true})
keymap.set("n","<leader>rg",":reg<CR>")
keymap.set("n","<leader>ms",":marks<CR>")
keymap.set({"n","i","v"},"<c-s>",":w<CR>")
