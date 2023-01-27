local obg = require("open-browser-github")

vim.api.nvim_create_user_command("ErGetFileGithubUrl", function(opts)
	obg.get_file_url()
end, {})
