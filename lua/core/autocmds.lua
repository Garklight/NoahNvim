-- Dno't auto commenting new lines
vim.api.nvim_create_autocmd("BufEnter",{
  pattern = "",
  command = "set fo-=c fo-=r fo-=o",
})

--auto change language
local config_path = string.gsub(vim.fn.stdpath "config", "\\", "/")
local im_select_path = config_path .. "/im-select/im-select.exe"

local f = io.open(im_select_path, "r")
if f ~= nil then
  io.close(f)

  local ime_autogroup = vim.api.nvim_create_augroup("ImeAutoGroup", { clear = true })

  local function autocmd(event, code)
    vim.api.nvim_create_autocmd(event, {
      group = ime_autogroup,
      callback = function()
        vim.cmd(":silent :!" .. im_select_path .. " " .. code)
      end,
    })
  end

  autocmd("InsertLeave", 1033)
  autocmd("InsertEnter", 2052)
  autocmd("VimLeavePre", 2052)
  autocmd("BufEnter", 1033)
end
