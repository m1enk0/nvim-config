return {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
        local jdtls = require('jdtls')
        -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
        local workspace_dir = vim.fn.stdpath("data") .. "\\site\\java\\workspace-root\\" .. project_name
        local home = vim.env.HOME
        local config = {
            init_options = {
                extendedClientCapabilities = jdtls.extendedClientCapabilities,
            },
            cmd = {
                -- 💀
                'java', -- or '/path/to/java17_or_newer/bin/java'
                -- 'C:/Program Files/Java/jdk-21/bin/java', -- or '/path/to/java17_or_newer/bin/java'
                -- depends on if `java` is in your $PATH env variable and if it points to the right version.

                '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                '-Dosgi.bundles.defaultStartLevel=4',
                '-Declipse.product=org.eclipse.jdt.ls.core.product',
                '-Dlog.protocol=true',
                '-Dlog.level=ALL',
                '-javaagent:' .. home .. '/AppData/Local/nvim-data/mason/packages/jdtls/lombok.jar',

                '-Xmx1g',
                '--add-modules=ALL-SYSTEM',
                '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

                -- 💀
                '-jar',
                home .. '/AppData/Local/nvim-data/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.7.100.v20251014-1222.jar',
                -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
                -- Must point to the                                                     Change this to
                -- eclipse.jdt.ls installation                                           the actual version


                -- 💀
                '-configuration', home .. '/AppData/Local/nvim-data/mason/packages/jdtls/config_win',
                -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
                -- Must point to the                      Change to one of `linux`, `win` or `mac`
                -- eclipse.jdt.ls installation            Depending on your system.


                -- 💀
                -- See `data directory configuration` section in the README
                '-data', workspace_dir
            },
            -- on_attach = on_attach,
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
