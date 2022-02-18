M = {}
M.opts = {}

M.setup = function(opts)
	opts = opts or {}
	M.opts = M.opts or {}
	M.opts = vim.tbl_deep_extend("force", M.opts, opts)
end

return M
