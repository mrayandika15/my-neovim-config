local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
          local lazyrepo = "https://github.com/folke/lazy.nvim.git"
          local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
          if vim.v.shell_error ~= 0 then
                    vim.api.nvim_echo({
                              { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                              { out, "WarningMsg" },
                              { "\nPress any key to exit..." },
                    }, true, {})
                    vim.fn.getchar()
                    os.exit(1)
          end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
          spec = {
                    -- add LazyVim and import its plugins
                    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
                    { import = "lazyvim.plugins.extras.linting.eslint" },
                    { import = "lazyvim.plugins.extras.formatting.prettier" },
                    { import = "lazyvim.plugins.extras.lang.typescript" },
                    { import = "lazyvim.plugins.extras.lang.json" },
                    { import = "lazyvim.plugins.extras.lang.rust" },
                    { import = "lazyvim.plugins.extras.lang.tailwind" },
                    { import = "lazyvim.plugins.extras.util.mini-hipatterns" },

                    -- import/override with your plugins
                    { import = "plugins" },
                    { "mlaursen/vim-react-snippets" },

                    -- Lua formatter setup
                    {
                              "mhartington/formatter.nvim",
                              config = function()
                                        require("formatter").setup({
                                                  logging = false,
                                                  filetype = {
                                                            lua = {
                                                                      function()
                                                                                return {
                                                                                          exe = "lua-format",
                                                                                          args = {
                                                                                                    "--no-keep-simple-function-one-line",
                                                                                                    "--no-break-after-operator",
                                                                                          },
                                                                                          stdin = true,
                                                                                }
                                                                      end,
                                                            },
                                                  },
                                        })
                              end,
                    },

                    -- add your new colorscheme plugin here
                    {
                              "olimorris/onedarkpro.nvim",
                              priority = 1000, -- Ensure it loads first
                              config = function()
                                        require("onedarkpro").setup({
                                                  styles = {
                                                            types = "NONE",
                                                            methods = "NONE",
                                                            numbers = "NONE",
                                                            strings = "NONE",
                                                            comments = "italic",
                                                            keywords = "bold,italic",
                                                            constants = "NONE",
                                                            functions = "italic",
                                                            operators = "NONE",
                                                            variables = "NONE",
                                                            parameters = "NONE",
                                                            conditionals = "italic",
                                                            virtual_text = "NONE",
                                                  },
                                        })
                                        vim.cmd("colorscheme onedark")
                              end,
                    },
                    {
                              "supermaven-inc/supermaven-nvim",
                              config = function()
                                        require("supermaven-nvim").setup({
                                                  keymaps = {
                                                            accept_suggestion = "<C-y>",
                                                  },
                                        })
                              end,
                    },
          },
          defaults = {
                    lazy = false, -- set to true if you want all custom plugins to be lazy-loaded
                    version = false, -- always use the latest git commit
          },
          install = { colorscheme = { "tokyonight", "habamax", "onedarkpro" } },
          checker = { enabled = true }, -- automatically check for plugin updates
          performance = {
                    rtp = {
                              disabled_plugins = {
                                        "gzip",
                                        "tarPlugin",
                                        "tohtml",
                                        "tutor",
                                        "zipPlugin",
                              },
                    },
          },
})

-- Auto-format Lua files on save
vim.cmd([[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost *.lua FormatWrite
  augroup END
]])
