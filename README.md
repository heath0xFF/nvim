# nvim config

I've committed to using neovim as my main editor. So, we're sticking to this config for a long time.

## Plugin Manager

- [lazy.nvim](https://github.com/folke/lazy.nvim)

## Plugins

| Plugin | Purpose |
|--------|---------|
| Stillwater (`~/code/stillwater`) | Local color theme and matching status line |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configuration |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP server package manager |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting and code parsing |
| [blink.cmp](https://github.com/saghen/blink.cmp) | Completion engine (Rust-based fuzzy matcher) |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Code formatting (stylua, prettier) |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Status line |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | File explorer (buffer-based) |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git integration and inline blame |

## Setup

This setup is tested with Neovim 0.13-dev. Keep the local Stillwater checkout at
`~/code/stillwater`. Tree-sitter needs a C compiler and the Tree-sitter CLI
(version 0.26.1 or later). On macOS, install the CLI with Homebrew, not npm:

```sh
brew install tree-sitter-cli
```

Install the language servers and formatters from Neovim:

```vim
:MasonInstall lua-language-server pyright stylua prettier
```

Neovim enables the language servers directly; Mason only manages the tools.
Tree-sitter installs missing parsers from `lua/configs/treesitter.lua` at startup.
On a fresh setup, wait for installation to finish, then reopen the file to enable
highlighting. Run `:TSUpdate` after updating the Tree-sitter plugin.

## LSP Servers

- **lua_ls** — Lua, with `vim` global recognized
- **pyright** — Python (type checking currently disabled)

## Key Mappings

Leader key: `Space`

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ff` | n | Find files |
| `<leader>fg` | n | Live grep |
| `<leader>fb` | n | List buffers |
| `<leader>fh` | n | Help tags |
| `<leader>ft` | n | Treesitter symbols |
| `<leader>fd` | n | Diagnostics |
| `<leader>fr` | n | LSP references |
| `<leader>fs` | n | Document symbols |
| `<leader>fw` | n | Workspace symbols |
| `<leader>fl` | n | Code actions |
| `<leader>fm` | n | Format file |
| `<leader>/` | n/v | Toggle comment |
| `<leader>x` | n | Close buffer |
| `<leader>n` | n | Toggle line numbers |
| `<leader>j` | n | Insert journal template |
| `<tab>` / `<S-tab>` | n | Next / previous buffer |
| `-` | n | Open parent directory (oil) |
| `gd` | n | Go to definition |
| `gr` | n | Go to references |
| `K` | n | Hover docs |
| `<F2>` | n | Rename symbol |
| `<F4>` | n | Code actions |

## Formatting

Format on save is enabled for:
- **Lua** — stylua
- **JSON / CSS / JavaScript** — prettier

Prettier uses the project configuration. This setup does not force an indentation
width. Other filetypes have no automatic formatter configured.

## Structure

```
init.lua                    Main entry point
lua/
  plugins.lua               Plugin specifications (lazy.nvim)
  options.lua               Editor options
  mappings.lua              Key bindings
  configs/
    lazy.lua                lazy.nvim bootstrap
    lspconfig.lua           LSP setup and keymaps
    mason.lua               Mason package manager config
    telescope.lua           Telescope fuzzy finder
    treesitter.lua          Parser installation list
    lualine.lua             Status line
    conform.lua             Formatter configuration
    gitsigns.lua            Git signs and blame
```

## Check the setup

After installing the tools and parsers, run this from the config directory:

```sh
nvim --headless -i NONE "+lua dofile('tests/smoke.lua')"
```

This checks plugin loading, tool availability, Python settings, and Tree-sitter
highlighting. It exits with a nonzero status on failure.

## Notes

- I tried nvim-tree, and i loved it a lot. but oil is a bit quicker, and i like how it handles file editing, creating, and deleting.
- Completion is disabled in `/root/personal-notes/` directory.
- There are `TODO` comments scattered throughout the config files marking areas for potential improvement — grep for `TODO` to find them all.
