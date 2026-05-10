return {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
        local jdtls_path = vim.fn.stdpath("data") .. "\\mason\\packages\\jdtls\\"
        local launcher_jar = vim.fn.glob(jdtls_path .. "plugins\\org.eclipse.equinox.launcher_*.jar")
        local config_path = jdtls_path .. "config_win"
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
        local workspace_dir = vim.fn.stdpath("data") .. "\\jdtls-workspace\\" .. project_name

        local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
        capabilities.textDocument.completion.completionItem.snippetSupport = false

        -- Ensure the current buffer is a Java file
        if vim.bo.filetype ~= "java" then
            return
        end

        -- Define the command to start jdtls
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

        -- Start or attach to the JDTLS server
        require("jdtls").start_or_attach({
            cmd = java_cmd,
            root_dir = require("jdtls.setup").find_root({ "pom.xml", "build.gradle", ".git", "mvnw", "gradlew" }),
            capabilities = capabilities,
            init_options = {
                bundles = {
                    vim.fn.glob(vim.fn.stdpath("data") .. "\\mason\\packages\\java-debug-adapter\\extension\\server\\com.microsoft.java.debug.plugin-*.jar")
                },
                shouldLanguageServerExitOnShutdown = true,
                settings = {
                    java = {
                        import = {
                            gradle = {
                                enabled = false,
                            },
                            maven = {
                                enabled = false,
                            },
                        },
                    },
                    configuration = {
                        updateBuildConfiguration = "interactive",
                    },
                    autobuild = {
                        enabled = false,
                    },
                },
            },
            commands = {
                ['java.show.references'] = vim.lsp.commands['editor.action.showReferences'],
                ['java.show.implementations'] = vim.lsp.commands['editor.action.showReferences'],
            },
            settings = {
                java = {
                    configuration = {
                        updateBuildConfiguration = "interactive",
                    },
                    completion = {
                        maxResults = 500,
                    },
                    referencesCodeLens = {
                        enabled = false, -- slow
                    },
                    implementationsCodeLens = {
                        enabled = false, -- slow
                    },
                    inlayHints = {
                        parameterNames = {
                            enabled = 'all',
                        },
                    },
                    signatureHelp = { 
                        enabled = false, -- if enabled causes treesitter error when signatureHelp is invoked
                    },
                    contentProvider = {
                        preferred = 'fernflower'
                    },
                },
            },
            handlers = {
                ['$/progress'] = function(err, result, ctx)
                    local msg = result.value and result.value['message']
                    if msg and vim.startswith(msg, 'Validate documents') then
                        return
                    end
                    if msg and vim.startswith(msg, 'Publish Diagnostics') then
                        return
                    end
                    if msg and vim.startswith(msg, 'Building') then
                        return
                    end
                    -- pass through to normal handler
                    vim.lsp.handlers['$/progress'](err, result, ctx)
                end,
            },
            flags = {
                allow_incremental_sync = true
            },
        })
    end,
}

