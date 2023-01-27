local M = {}

local Job = require("plenary.job")

M.get_file_url = function(name, firstlinenumber, lastlinenumber)
	local fileAbs = vim.api.nvim_buf_get_name(0)
	local baseProj =
		string.gsub("/Users/er/Develop/neovim/plugings/open-browser-github.nvim", "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
	local fileRelative = string.gsub(fileAbs, baseProj, "")
	print(fileRelative)
end

M.get_repo_url = function()
	local result
	local job = Job:new({
		command = "git",
		args = { "remote", "get-url", "origin" },
		on_stdout = function(_, line)
			result = line:sub(1, -5) -- remove .git at the end
			result = result:gsub("git@", "https://")
			result = result:gsub("github.com:", "github.com/")
		end,
	})
	job:sync()
	return result
end

M.get_issue_url = function(number)
	local url = M.get_repo_url()
	return url .. "/issues/" .. number
end

M.get_pullreq_url = function(number)
	local url = M.get_repo_url()
	return url .. "/pull/" .. number
end

M.get_commit_url = function(hash)
	local url = M.get_repo_url()
	return url .. "/commit/" .. hash
end

M.open_file = function(name, firstlinenumber, lastlinenumber) end

M.open_repo = function()
	local url = M.get_repo_url()
	vim.fn["openbrowser#open"](url)
end

M.open_issue = function(number)
	local url = M.get_issue_url(number)
	vim.fn["openbrowser#open"](url)
end

M.open_pullreq = function(number)
	local url = M.get_pullreq_url(number)
	vim.fn["openbrowser#open"](url)
end

M.open_commit = function(hash)
	local url = M.get_commit_url(hash)
	vim.fn["openbrowser#open"](url)
end

print(M.open_commit("2744f49748271bfcec60e130807ba4a07f47cc9e"))

return M
