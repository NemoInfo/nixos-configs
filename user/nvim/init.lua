--[[**************************************@******************************************
*                                  BASIC SETTINGS                                   *
*********************************************************************************--]]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.shell = "zsh"
-- Override tab settings for all file types
vim.cmd([[
  autocmd FileType * setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
]])

-- KEYMAPS
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })                -- Save
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true })                -- Quit
vim.keymap.set("n", "<leader>R", ":luafile $MYVIMRC<CR>", { noremap = true, silent = true }) -- Reload config
vim.keymap.set("n", "<leader>W", "<C-w>w", { noremap = true, silent = true })                -- Change window
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { noremap = true })                        -- Buffer Delete
vim.keymap.set("n", "<leader>bD", ":bdelete!<CR>", { noremap = true })                       -- Buffer Delete !
vim.keymap.set("n", "<leader>bp", ":bp<CR>", { noremap = true })                             -- Previous Buffer
vim.keymap.set("n", "<leader>bn", ":bn<CR>", { noremap = true })                             -- Next Buffer
vim.keymap.set("n", "<ESC>", function()
	vim.cmd("nohlsearch")
	return "<ESC>"
end, { expr = true, noremap = true })

-- Configure clipboard
vim.opt.clipboard:append("unnamedplus")
--[[**************************************@******************************************
*                                      THEME                                        *
*********************************************************************************--]]
local kanagawa_config = {
	transparent = true,
	colors = {
		theme = {
			all = {
				ui = {
					bg_gutter = "none",
				},
			},
		},
	},
}
require("kanagawa").setup(kanagawa_config)
vim.cmd("colorscheme kanagawa")
vim.cmd("highlight CursorLineNr guifg=#957fb8")

local function toggle_transparency()
	kanagawa_config.transparent = not kanagawa_config.transparent
	require("kanagawa").setup(kanagawa_config)
	vim.cmd("colorscheme kanagawa")
	vim.cmd("highlight CursorLineNr guifg=#957fb8")
end

vim.keymap.set("n", "<leader>T", toggle_transparency, { noremap = true, silent = true })

--[[**************************************@******************************************
*                                        Oil                                        *
*********************************************************************************--]]
local oil = require("oil")
oil.setup({
	float = {
		win_options = {
			winblend = 0,
		},
	},
})
vim.keymap.set("n", "-", function()
	vim.cmd("Oil")
end, { desc = "Open parent directory and show CWD" })

local function oil_or_buff_wd()
	return oil.get_current_dir() or vim.api.nvim_buf_get_name(0)
end

--[[**************************************@******************************************
*                                      LUALINE                                      *
*********************************************************************************--]]
require("lualine").setup({
	sections = {
		lualine_c = {
			function()
				if vim.bo.filetype == "oil" then
					return oil.get_current_dir():gsub(vim.env.HOME, "~")
				else
					return vim.fn.expand("%:t")
				end
			end,
		},
	},
})

--[[**************************************@******************************************
*                                     TELESCOPE                                     *
*********************************************************************************--]]
require("telescope").setup({
	extensions = {
		fzf = {
			fuzzy = true,                -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case",
		},
	},
	pickers = {
		colorscheme = { enable_preview = true, theme = "ivy" },
		live_grep = {
			theme = "ivy",
			file_ignore_patterns = { ".git" },
		},
		find_files = {
			theme = "ivy",
			hidden = true,
			find_command = {
				"rg",
				"--files",
				"--glob",
				"!{.git/*,target/*}",
			},
		},
		lsp_type_definitions = { theme = "ivy" },
		lsp_references = { theme = "ivy" },
		lsp_document_symbols = { theme = "ivy" },
		current_buffer_fuzzy_find = { theme = "ivy" },
		treesitter = { theme = "ivy" },
		oldfiles = { theme = "ivy" },
		help_tags = { theme = "ivy" },
		buffers = { theme = "ivy" },
		grep_string = { theme = "ivy" },
	},
})
local telescope_builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>lt", telescope_builtin.lsp_type_definitions, {})
vim.keymap.set("n", "<leader>lr", telescope_builtin.lsp_references, {})
vim.keymap.set("n", "<leader>ls", telescope_builtin.lsp_document_symbols, {})
vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, {})
vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, {})
vim.keymap.set("n", "<leader>fm", telescope_builtin.marks, {})
vim.keymap.set("n", "<leader>fr", telescope_builtin.oldfiles, {})
vim.keymap.set("n", "<leader>ft", telescope_builtin.treesitter, {})
vim.keymap.set("n", "<leader>fgw", telescope_builtin.grep_string, {})
vim.keymap.set("n", "<leader>fgb", telescope_builtin.current_buffer_fuzzy_find, {})
vim.keymap.set("n", "<leader>fgp", function()
	telescope_builtin.live_grep({ cwd = oil_or_buff_wd() })
end, {})
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, {})

--[[**************************************@******************************************
*                                        CMP                                        *
*********************************************************************************--]]
local cmp = require("cmp")
cmp.setup({
	mapping = {
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
	}, {
		{ name = "buffer" },
	}),
})

--[[**************************************@******************************************
*                                        UFO (folding)                              *
*********************************************************************************--]]
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

local ufo = require("ufo")
vim.keymap.set("n", "zR", ufo.openAllFolds)
vim.keymap.set("n", "zM", ufo.closeAllFolds)
vim.keymap.set("n", "zK", function()
	local winid = ufo.peekFoldedLinesUnderCursor()
	if not winid then
		vim.lsp.buf.hover()
	end
end)

ufo.setup({
	provider_selector = function(bufnr, filetype, buftype)
		return { "treesitter", "indent" }
	end,
})

-- Safe previous paragraph
vim.keymap.set("n", "{", function()
	local prev = vim.fn.line(".")
	repeat
		vim.cmd("normal! {")
		local curr = vim.fn.line(".")
		if curr == prev then
			break
		end -- stop if stuck
		prev = curr
	until vim.fn.foldclosed(curr) == -1
end, { noremap = true })

-- Safe next paragraph
vim.keymap.set("n", "}", function()
	local prev = vim.fn.line(".")
	repeat
		vim.cmd("normal! }")
		local curr = vim.fn.line(".")
		if curr == prev then
			break
		end -- stop if stuck
		prev = curr
	until vim.fn.foldclosed(curr) == -1
end, { noremap = true })

--[[**************************************@******************************************
*                                        LSP                                        *
*********************************************************************************--]]
vim.diagnostic.config({
	virtual_text = true,     --  Show diagnostics as virtual text (inline)
	signs = true,            --	 Show signs in the gutter
	underline = true,        --  Underline problematic code
	update_in_insert = false, -- Don't show diagnostics while typing
	severity_sort = true,    --  Sort diagnostics by severity
})
vim.o.signcolumn = "yes"

local on_attach = function(_, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	-- Define key mappings for LSP functions
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)            -- Go to definition
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)        -- Go to implementation
	-- vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, opts)    -- Done by telescope
	vim.keymap.set("n", "<leader>ld", vim.lsp.buf.hover, opts)         -- Hover documentation
	vim.keymap.set("n", "<leader>lh", vim.lsp.buf.signature_help, opts) -- Signature hint
	vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, opts)        -- Rename variable
	vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)   -- Code actions
	vim.keymap.set("n", "<leader>le", function()
		vim.diagnostic.goto_next()
		vim.cmd("normal! zz")
	end, opts) -- Next error
end

local lspconfig = require("lspconfig")
--[[**************************************@******************************************
*                                      NULL-LS (LSP)                                *
*********************************************************************************--]]
local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.yapf.with({
			extra_args = {
				"--style",
				"{based_on_style: pep8, indent_width: 2, column_limit: 120, spaces_before_comment: '15,20'}",
			},
		}),
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.latexindent,
		null_ls.builtins.formatting.nixfmt,
		null_ls.builtins.formatting.rustfmt,
	},

	-- Format on save
	on_attach = function(client, _)
		if client.server_capabilities.documentFormattingProvider then
			vim.cmd([[ augroup LspFormatting
         autocmd! * <buffer>
         autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = true }); vim.defer_fn(function() vim.api.nvim_buf_set_option(0, "modified", false) end, 200)
         augroup END
     ]])
		end
	end,
})

--[[**************************************@******************************************
*                                       C/C++                                       *
*********************************************************************************--]]
require("lspconfig").clangd.setup({
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_dir = require("lspconfig.util").root_pattern("compile_commands.json", ".git"),
	single_file_support = true,
})

--[[**************************************@******************************************
*                                      PYTHON                                       *
*********************************************************************************--]]
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.pyright.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

--[[**************************************@******************************************
*                                        LUA                                        *
*********************************************************************************--]]
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" }, -- Recognize `vim` as a global
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
			telemetry = { -- Disable spies
				enable = false,
			},
		},
	},
	on_attach = on_attach,
})

--[[**************************************@******************************************
*                                        NIX                                        *
*********************************************************************************--]]
lspconfig.nil_ls.setup({
	on_attach = on_attach,
	settings = {
		["nil"] = {
			formatting = {
				command = { "nixfmt" },
			},
		},
	},
})

--[[**************************************@******************************************
*                                       JULIA                                       *
*********************************************************************************--]]
vim.g.latex_to_unicode_tab = 1
vim.g.latex_to_unicode_suggestions = 1

--[[**************************************@******************************************
*                                        RUST                                       *
*********************************************************************************--]]
local rt = require("rust-tools")

rt.setup({
	server = {
		on_attach = on_attach,
	},
})

--[[**************************************@******************************************
*                                      TERMINAL                                     *
*********************************************************************************--]]
vim.api.nvim_set_keymap("n", "<leader>t", ":vsplit | wincmd l | term<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<escape>", [[<C-\><C-n>]], { noremap = true, silent = true })
-- Terminal mode cursor
vim.cmd([[
  augroup TerminalCursorColor
    autocmd!
    autocmd TermEnter * highlight TermCursor guifg=#7e9cd8
  augroup END
]])

--[[**************************************@******************************************
*                                       TYPST                                       *
*********************************************************************************--]]
require("lspconfig").tinymist.setup({
	settings = {
		formmaterMode = "typstyle",
	},
})
vim.g.typst_conceal = 1
vim.g.typst_conceal_emoji = 1
vim.g.typst_conceal_math = 1

--[[**************************************@******************************************
*                                       LATEX                                       *
*********************************************************************************--]]
vim.g.vimtex_view_method = "general"
vim.g.vimtex_general_viewer = "sioyek"
vim.g.vimtex_general_options =
'--shell-escape --forward-search-file @tex --forward-search-line @line --inverse-search "nvim --headless -c \\"VimtexInverseSearch %2 \'%1\'\\""'
vim.g.vimtex_compiler_method = "latexmk"

-- Autocommand to set Vimtex options when opening LaTeX files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function()
		vim.g.vimtex_view_method = "general"
		vim.g.vimtex_view_general_viewer = "sioyek"
		vim.g.vimtex_view_general_options =
		'--forward-search-file @tex --forward-search-line @line --inverse-search "nvim --headless -c \\"VimtexInverseSearch %2 \'%1\'\\""'
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function()
		-- Keymap for VimtexCompile
		vim.api.nvim_buf_set_keymap(0, "n", "<leader>c", ":VimtexCompile<CR>", { noremap = true, silent = true })
		-- Keymap for VimtexView
		vim.api.nvim_buf_set_keymap(0, "n", "<leader>v", ":VimtexView<CR>", { noremap = true, silent = true })
	end,
})

-- Configure Texlab
lspconfig.texlab.setup({
	settings = {
		texlab = {
			build = {
				executable = "latexmk",
				args = { "-pdf", "--shell-escape", "-interaction=nonstopmode", "-synctex=1", "%f" },
				onSave = true, -- Automatically build on save
			},
			auxDirectory = ".", -- I should tinker with this
			diagnostics = {
				enabled = true,
				delay = 300,
			},
		},
	},
	on_attach = on_attach,
})

--[[**************************************@******************************************
*                              ALPHA DASHBOARD SETTINGS                             *
*********************************************************************************--]]
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

vim.api.nvim_set_keymap("n", "<leader>h", ":Alpha<CR>", { noremap = true, silent = true })

dashboard.section.header.val = {
	[[                                                                       ]],
	[[ ╔██████  ╔█████                  ╔█████  ╔█████ ╔███                  ]],
	[[ ╚╗██████ ╚╗███                   ╚╗███   ╚╗███╝ ╚══╝                  ]],
	[[  ║███║███ ║███  ╔██████  ╔██████  ║███    ║███ ╔████ ╔█████████████   ]],
	[[  ║███╚╗███║███ ╔███═╗███╔███═╗███ ║███    ║███ ╚╗███ ╚╗███═╗███═╗███  ]],
	[[  ║███ ╚╗██████ ║███████╝║███ ║███ ╚╗███   ███╝  ║███  ║███ ║███ ║███  ]],
	[[  ║███  ╚╗█████ ║███═══╝ ║███ ║███  ╚═╗█████═╝   ║███  ║███ ║███ ║███  ]],
	[[ ╔█████  ╚╗█████╚╗██████ ╚╗██████     ╚╗███╝    ╔█████╔█████║███╔█████ ]],
	[[ ╚════╝   ╚════╝ ╚═════╝  ╚═════╝      ╚══╝     ╚════╝╚════╝╚══╝╚════╝ ]],
	[[                                                                       ]],
}

dashboard.section.buttons.val = {
	dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"), -- New file
	dashboard.button("SPC f f", "󰍉  Find file"), -- Find file
	dashboard.button("SPC f r", "  Recent"), -- Recent files
	dashboard.button("SPC f g", "  Grep"), -- Grep
	dashboard.button("c", "  Configuration", ":e ~/.dotfiles/user/nvim/init.lua<CR>"), -- Open neovim config
	dashboard.button("h", "  Home manager", ":e ~/.dotfiles/user/home.nix<CR>"), -- Open home manager
	dashboard.button("t", "󰆍  Terminal", ":terminal<CR>i"), -- Open home manager
	dashboard.button("q", "󰈆  Quit NVIM", ":qa<CR>"), -- Quit Neovim
}

local function footer_padding()
	local total_height = #dashboard.section.header.val + #dashboard.section.buttons.val + #dashboard.section.footer.val
	local screen_height = vim.fn.winheight(0)
	local padding = math.floor((screen_height - total_height) / 2)
	return padding > 0 and padding or 0
end

dashboard.config.layout = {
	{ type = "padding", val = footer_padding() },
	dashboard.section.header,
	{ type = "padding", val = 2 },
	dashboard.section.buttons,
	{ type = "padding", val = 1 },
	dashboard.section.footer,
}

alpha.setup(dashboard.config)

--[[**************************************@******************************************
*                                        GIT                                        *
********************************************************************************--]]
local function _lazygit_close()
	local bufname = vim.api.nvim_buf_get_name(0)
	vim.cmd("stopinsert")
	if string.match(bufname, "lazygit") then
		vim.cmd("bdelete!")
	end
end

local function _lazygit_open()
	local cwd = vim.fn.getcwd()
	if vim.bo.filetype == "oil" then
		vim.cmd("lcd" .. oil.get_current_dir())
		vim.cmd("LazyGit")
		vim.cmd("lcd" .. cwd)
	else
		vim.cmd("LazyGitCurrentFile")
	end
end

vim.keymap.set("t", "<Esc>", _lazygit_close, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>g", _lazygit_open, { noremap = true, silent = true })
