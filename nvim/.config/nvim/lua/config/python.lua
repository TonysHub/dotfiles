local M = {}

-- Pick a project interpreter without resolving its symlink: the venv path is
-- what lets Python tooling find that environment's site-packages.
function M.interpreter(root)
  local candidates = {}
  for _, env in ipairs({ "VIRTUAL_ENV", "CONDA_PREFIX" }) do
    local path = vim.env[env]
    if path and path ~= "" then
      candidates[#candidates + 1] = path .. "/bin/python"
    end
  end
  if root and root ~= "" then
    for _, path in ipairs({ ".venv/bin/python", "venv/bin/python", ".venv/" .. vim.fs.basename(root) .. "/bin/python" }) do
      candidates[#candidates + 1] = root .. "/" .. path
    end
  end
  for _, path in ipairs(candidates) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  local python = vim.fn.exepath("python3")
  return python ~= "" and python or vim.fn.exepath("python")
end

return M
