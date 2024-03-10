return {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
	local jdtls = require('jdtls')
	local on_attach = function(client, bufnr)
	    require("lazyvim.plugins.lsp.keymaps").on_attach(client, bufnr)

	end

	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local workspace_dir = vim.fn.stdpath("data") .. "\\site\\java\\workspace-root\\" .. project_name
	local config = {
	    init_options = {
		extendedClientCapabilities = jdtls.extendedClientCapabilities,
	    },
	    cmd = {
		-- 💀
		'java', -- or '/path/to/java17_or_newer/bin/java'
		-- depends on if `java` is in your $PATH env variable and if it points to the right version.

		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		'-Xmx1g',
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'--add-opens', 'java.base/java.lang=ALL-UNNAMED',

		-- 💀
		'-jar', 'C:/Users/Andrey/AppData/Local/nvim-data/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.700.v20231214-2017.jar',
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
		-- Must point to the                                                     Change this to
		-- eclipse.jdt.ls installation                                           the actual version


		-- 💀
		'-configuration', 'C:/Users/Andrey/AppData/Local/nvim-data/mason/packages/jdtls/config_win',
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
		-- Must point to the                      Change to one of `linux`, `win` or `mac`
		-- eclipse.jdt.ls installation            Depending on your system.


		-- 💀
		-- See `data directory configuration` section in the README
		'-data', workspace_dir
	    },
	    on_attach = on_attach,
	    capabilities = capabilities,
	    root_dir = vim.fs.dirname(
		vim.fs.find({ ".gradlew", ".git", "mvnw", "pom.xml", "build.gradle" }, { upward = true })[1]
	    ),
	}
	vim.api.nvim_create_autocmd("FileType", {
	    pattern = "java",
	    callback = function()
		jdtls.start_or_attach(config)
	    end,
	})
    end,
}
