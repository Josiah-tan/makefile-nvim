M = {}

M.fileExists = function(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return true else return false end
end

M.splitWhiteSpace = function(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

M.getSelection = function(prompt_bufnr)
	-- local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr) -- did they change the API or something?
	local content = require("telescope.actions.state").get_selected_entry()
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



M.concatenateTable = function(t1, t2)
	for i=1,#t2 do
		t1[#t1+1] = t2[i]  --corrected bug. if t1[#t1+i] is used, indices will be skipped
	end
	return t1
end

M.tableContains = function(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end
return M
