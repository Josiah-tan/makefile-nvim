M = {}
-- M.opts = {} -- I don't think this is necessary, but put here just in case

M.setup = function(opts)
	opts = opts or {}
	M.opts = M.opts or {}
	M.opts = vim.tbl_deep_extend("force", M.opts, opts)
end

return M
