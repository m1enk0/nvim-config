function setup_jdtls()
    if not project_settings.lsp.jdtls or not project_settings.lsp.jdtls.enabled then
        vim.lsp.enable("jdtls", false)
        return
    end

    local jdtls_path = vim.fn.stdpath("data") .. "\\mason\\packages\\jdtls\\"
    local launcher_jar = vim.fn.glob(jdtls_path .. "plugins\\org.eclipse.equinox.launcher_*.jar")
    local config_path = jdtls_path .. "config_win"
    local root_dir = require("jdtls.setup").find_root({ "pom.xml", "build.gradle", ".git", "mvnw", "gradlew" })
    local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
    local workspace_dir = vim.fn.stdpath("data") .. "\\jdtls-workspace\\" .. project_name

    local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
    local extendedClientCapabilities = require('jdtls').extendedClientCapabilities
    -- capabilities.textDocument.completion.completionItem.snippetSupport = false

    local java_cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        '-javaagent:' .. jdtls_path .. '\\lombok.jar',

        "-Xms1g",
        "-Xmx4g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", launcher_jar,
        "-configuration", config_path,
        "-data", workspace_dir
    }

    require("jdtls").start_or_attach({
        cmd = java_cmd,
        root_dir = root_dir,
        capabilities = capabilities,
        init_options = {
            bundles = {
                vim.fn.glob(vim.fn.stdpath("data") ..
                    "\\mason\\packages\\java-debug-adapter\\extension\\server\\com.microsoft.java.debug.plugin-*.jar")
            }
        },
        settings = {
            java = {
                extendedClientCapabilities = extendedClientCapabilities,
                import = {
                    gradle = {
                        offline = { enabled = project_settings.lsp.jdtls.offline },
                        wrapper = { enabled = true },
                        enabled = true,
                    },
                    maven = {
                        offline = { enabled = project_settings.lsp.jdtls.offline },
                        enabled = true,
                    },
                },
                autobuild = {
                    enabled = false,
                },
                configuration = {
                    updateBuildConfiguration = "interactive",
                },
                completion = {
                    guessMethodArguments = {
                        off = 'off'
                    },
                    maxResults = 500,
                },
                referencesCodeLens = {
                    enabled = false,     -- slow
                },
                implementationsCodeLens = {
                    enabled = false,     -- slow
                },
                inlayHints = {
                    parameterNames = {
                        enabled = 'all',
                    },
                },
                signatureHelp = {
                    enabled = true,
                },
                contentProvider = {
                    preferred = 'fernflower'
                },
            },
        },
        handlers = {
            ['$/progress'] = function(err, result, ctx)
                local msg = result.value and result.value['message']
                if msg and (vim.startswith(msg, 'Validate documents') 
                    or vim.startswith(msg, 'Publish Diagnostics') 
                    or vim.startswith(msg, 'Building')) then
                    return
                end
                vim.lsp.handlers['$/progress'](err, result, ctx)
            end,
        },
        flags = {
            allow_incremental_sync = true
        },
    })
end

return {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = setup_jdtls
}
