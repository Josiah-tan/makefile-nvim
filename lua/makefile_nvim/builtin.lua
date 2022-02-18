M = {}
M.opts = require("makefile_nvim").opts
M.temp = {}

local function fileExists(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return true else return false end
end

local function MakeFileExists()
	return fileExists(vim.fn.getcwd() .. "/Makefile")
end

local function makeSelection(selection)
	require("harpoon.term").sendCommand(M.temp.opts.term, "make %s \n", selection)
	require("harpoon.term").gotoTerminal(M.temp.opts.term)
end

local function splitWhiteSpace(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end


local function getMakeOptions()
	local grep = "grep '.PHONY' Makefile"
	local phony_removal = "sed 's/.PHONY:[ ]*//'"
	local commands = vim.trim(vim.fn.system(string.format("%s | %s", grep, phony_removal)))
	return splitWhiteSpace(commands)
end

M.getMakeOptions = function()
	getMakeOptions()
end

local function getSelection(prompt_bufnr)
	local content = require("telescope.actions.state").get_selected_entry(
	prompt_bufnr
	)
	local current_line = require("telescope.actions.state").get_current_line()
	require("telescope.actions").close(prompt_bufnr)
	if content then
		content = content.value
	else
		content = current_line
	end
	-- require("refactoring").refactor(content.value)
	return content
end

local function selectQuery(prompt_bufnr)
	makeSelection(getSelection(prompt_bufnr))
end

local function getAndMakeSelection(opts)
	require("telescope.pickers").new(opts, {
		prompt_title = "Make options >",
		finder = require("telescope.finders").new_table({
			results = getMakeOptions()
		}),
		sorter = require("telescope.config").values.generic_sorter(opts),
		attach_mappings = function(_, map)
			map("i", "<CR>", selectQuery)
			map("n", "<CR>", selectQuery)
			return true
		end
	}):find()
end

M.makeFile = function(opts)
	if MakeFileExists() then
		M.temp.opts = vim.tbl_deep_extend("force", M.opts, opts)
		vim.cmd[[wa]]
		if M.temp.opts.selection then
			makeSelection(M.temp.opts.selection)
		else
			getAndMakeSelection(M.temp.opts.telescope)
		end
	else
		print("Makefile does not exist so command ignored")
	end
end

return M
