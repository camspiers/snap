if 1 ~= vim.fn.has("nvim-0.9.0") then
	vim.api.nvim_err_writeln("snap requires at least nvim-0.9.0.")
	return
end

if vim.g.loaded_snap == 1 then
	return
end

vim.g.loaded_snap = 1

local highlights = {
	SnapSelect = { default = true, link = "Visual" },
	SnapMultiSelect = { default = true, link = "Type" },

	SnapNormal = { default = true, link = "Normal" },
	SnapBorder = { default = true, link = "SnapNormal" },

	SnapPosition = { default = true, link = "Identifier" },
	SnapPrompt = { default = true, link = "Identifier" },
}

for k, v in pairs(highlights) do
	vim.api.nvim_set_hl(0, k, v)
end
