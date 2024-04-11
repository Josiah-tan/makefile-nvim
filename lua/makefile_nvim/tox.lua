local _opts = require("makefile_nvim").opts
local utils = require("makefile_nvim.utils")
local extra_commands = {
	"--recreate",
}
M = {}

local function environmentFileExists()
	return utils.fileExists(vim.fn.getcwd() .. "/tox.ini")
end

local function makeSelection(selection, term)
	if selection ~= "" and not utils.tableContains(extra_commands, selection) then
		selection = "-e "..selection
	end
	require("harpoon.term").sendCommand(term, "tox %s \r", selection)
	require("harpoon.term").gotoTerminal(term)
end

local function getOptions()
	return utils.splitWhiteSpace(vim.fn.system("tox -a"),"\n")
end

local function selectQuery(term)
	return function (prompt_bufnr)
		makeSelection(utils.getSelection(prompt_bufnr), term)
	end
end

local function getAndPerformSelection(term, opts)
	require("telescope.pickers").new(opts, {
		prompt_title = "tox options >",
		finder = require("telescope.finders").new_table({
			results = utils.concatenateTable(getOptions(), extra_commands) -- might make this a private one
		}),
		sorter = require("telescope.config").values.generic_sorter(opts),
		attach_mappings = function(_, map)
			map("i", "<CR>", selectQuery(term))
			map("n", "<CR>", selectQuery(term))
			return true
		end
	}):find()
end

M.run = function (opts)
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
		print("Tox does not exist so command ignored")
	end
end


return M
