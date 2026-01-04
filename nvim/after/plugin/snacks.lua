-- Snacks - Collection of useful utilities
local status_ok, snacks = pcall(require, 'snacks')
if not status_ok then
  return
end

snacks.setup {
  rename = { enabled = true },
}
