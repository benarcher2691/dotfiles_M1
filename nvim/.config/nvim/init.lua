vim.g.mapleader = " "

-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

vim.opt.relativenumber = true
vim.opt.number = true

vim.keymap.set('n', 'gd', '<C-]>', { desc = 'Go to definition (ctags)' })

vim.opt.tags = { './tags', 'tags', 'sys.tags' }

vim.opt.path:append("**")  -- project files
vim.opt.path:append("/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include")

vim.keymap.set('n', '<leader>f', function()
	local tempfile = vim.fn.tempname()
	local original_win = vim.api.nvim_get_current_win()

	-- Bottom split with its *own* buffer
	vim.cmd('botright 15new')  -- new window + new empty buffer

	local term_win = vim.api.nvim_get_current_win()
	local term_buf = vim.api.nvim_get_current_buf()

	vim.fn.termopen('fzf > ' .. tempfile, {
		on_exit = function()
			local lines = vim.fn.readfile(tempfile)
			vim.fn.delete(tempfile)

			-- Close the terminal buffer/window only
			if vim.api.nvim_buf_is_valid(term_buf) then
				vim.api.nvim_buf_delete(term_buf, { force = true })
			end
			if vim.api.nvim_win_is_valid(term_win) then
				vim.api.nvim_win_close(term_win, true)
			end

			if #lines > 0 and lines[1] ~= '' then
				-- Go back to the original window and open selected file in a new buffer
				if vim.api.nvim_win_is_valid(original_win) then
					vim.api.nvim_set_current_win(original_win)
				end
				vim.cmd('edit ' .. vim.fn.fnameescape(lines[1]))
			end
		end,
	})

	vim.cmd('startinsert')
end, { desc = 'Find file' })

-- Grep project files for a pattern and open the selected match
vim.keymap.set('n', '<leader>g', function()
	-- Ask for search pattern
	local pattern = vim.fn.input('Grep for: ')
	if pattern == nil or pattern == '' then
		return
	end

	local tempfile = vim.fn.tempname()
	local original_win = vim.api.nvim_get_current_win()

	-- Bottom split with its own buffer
	vim.cmd('botright 15new')
	local term_win = vim.api.nvim_get_current_win()
	local term_buf = vim.api.nvim_get_current_buf()

	-- ripgrep + fzf: file:line:col:text
	local cmd = string.format(
		"rg --line-number --column --no-heading --color=never %s | fzf > %s",
		vim.fn.shellescape(pattern),
		tempfile
	)

	vim.fn.termopen(cmd, {
		on_exit = function()
			local ok, lines = pcall(vim.fn.readfile, tempfile)
			vim.fn.delete(tempfile)

			-- Close the terminal buffer/window
			if vim.api.nvim_buf_is_valid(term_buf) then
				vim.api.nvim_buf_delete(term_buf, { force = true })
			end
			if vim.api.nvim_win_is_valid(term_win) then
				vim.api.nvim_win_close(term_win, true)
			end

			if not ok or #lines == 0 or lines[1] == '' then
				return
			end

			-- Parse "file:line:col:text"
			local entry = lines[1]
			local parts = vim.split(entry, ':', { plain = true })
			local file = parts[1]
			local lnum = tonumber(parts[2]) or 1
			local col  = tonumber(parts[3]) or 1

			-- Back to original window and jump to location
			if vim.api.nvim_win_is_valid(original_win) then
				vim.api.nvim_set_current_win(original_win)
			end
			vim.cmd('edit ' .. vim.fn.fnameescape(file))
			vim.api.nvim_win_set_cursor(0, { lnum, math.max(col - 1, 0) })
		end,
	})

	vim.cmd('startinsert')
end, { desc = 'Grep files with rg + fzf' })
