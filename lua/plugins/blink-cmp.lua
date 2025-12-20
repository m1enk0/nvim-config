return {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
        'rafamadriz/friendly-snippets',
        'onsails/lspkind.nvim'
    },
    event = "VeryLazy",
    version = '1.*',
    -- use a release tag to download pre-built binaries
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    opts = {
        snippets = {
            expand = function(snippet, _)
                vim.snippet.expand(snippet)
                vim.snippet.stop()
            end,
        },
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { 
            preset = 'enter',
            ['<C-n>'] = { 'show' },
            ['<CR>'] = {   
                function(cmp) 
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-g>u', true, true, true), 'n', true) -- breaks actions (for Undo)
                    return cmp.accept() 
                end, 
                'fallback' 
            },
        },

        appearance = {
            -- use_nvim_cmp_as_default = true
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            -- nerd_font_variant = 'mono'
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = {
            menu = {
                draw = {
                    columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1} },
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                return require("lspkind").presets.codicons[ctx.kind] .. ctx.icon_gap
                            end
                        },
                        label = { width = { fill = false }, },
                        label_description = {
                            text = function (ctx) return ctx.item.detail end,
                            width = { fill = true }
                        }
                    }
                }
            },

            documentation = { auto_show = false, auto_show_delay_ms = 0 },
        -- menu = {
            --     -- Don't automatically show the completion menu
            --     auto_show = true,
            --
            --     draw = {
                --         columns = {
            --             { "kind_icon" },
            --             { "label", "label_description" }
            --             -- { "kind_icon", "kind" }
            --         }
            --     }
            -- }
            list = { selection = { preselect = true, auto_insert = false } },
            -- ghost_text = { enabled = true },
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = { default = { 'lsp', 'path', 'buffer' }, },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { 
            implementation = "rust",
            use_proximity = true
        },

        cmdline = {
            keymap = {
                preset = 'super-tab',
                ['<C-Right>'] = { 'accept', 'fallback' },
                ['<A-Enter>'] = { 'accept_and_enter', 'fallback' },
                ['<C-c>'] = { 'hide', 'fallback' }
            },
            completion = {
                menu = { auto_show = true },
                list = { selection = { preselect = true, auto_insert = false } }
            }
        }
    },
    opts_extend = { "sources.default" },
}

-- hi BlinkCmpLabelMatch guifg=#5490F5 gui=NONE
-- hi PmenuKind guibg=NONE
