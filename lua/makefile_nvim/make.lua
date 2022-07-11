local _opts = require("makefile_nvim").opts
local utils = require("makefile_nvim.utils")
M = {}

local function environmentFileExists()
	return utils.fileExists(vim.fn.getcwd() .. "/Makefile")
end

local function makeSelection(selection, term)
	require("harpoon.term").sendCommand(term, "make %s \n", selection)
	require("harpoon.term").gotoTerminal(term)
end


local function getOptions()
	local grep = "grep '.PHONY' Makefile"
	local phony_removal = "sed 's/.PHONY:[ ]*//'"
	local commands = vim.trim(vim.fn.system(string.format("%s | %s", grep, phony_removal)))
	return utils.splitWhiteSpace(commands)
end


local function selectQuery(term)
	return function (prompt_bufnr)
		makeSelection(utils.getSelection(prompt_bufnr), term)
	end
end


local function getAndPerformSelection(term, opts)
	require("telescope.pickers").new(opts, {
		prompt_title = "Make options >",
		finder = require("telescope.finders").new_table({
			results = getOptions()
		}),
		sorter = require("telescope.config").values.generic_sorter(opts),
		attach_mappings = function(_, map)
			map("i", "<CR>", selectQuery(term))
			map("n", "<CR>", selectQuery(term))
			return true
		end
	}):find()
end

M.run = function(opts)
	opts = opts or {}
	if environmentFileExists() then
		opts = vim.tbl_deep_extend("force", _opts, opts)
		vim.cmd[[wa]]
		if opts.selection then
			makeSelection(opts.selection, opts.term)
		else
			getAndPerformSelection(opts.term, opts.telescope)
		end
	else
		print("Makefile does not exist so command ignored")
	end
end

return M
