# Neovim Configuration

A comprehensive, modern Neovim configuration optimized for full-stack development with AI-powered assistance, extensive language support, and a rich UI experience.

## Features

- **AI-Powered Coding**: Integrated Claude AI assistant via Sidekick.nvim
- **Modern Completion**: Fast, extensible completion with Blink.cmp and GitHub Copilot
- **LSP Support**: Full Language Server Protocol integration with Mason
- **Rich UI**: Beautiful statusline, minimap, breadcrumbs, and notifications
- **Git Integration**: Multiple tools for seamless version control workflow
- **Testing & Debugging**: Built-in support for Python debugging and testing
- **Extensive Language Support**: 17+ languages with tailored configurations
- **Productivity Tools**: Note-taking (Obsidian), time tracking (Wakatime), presentations (Marp)

## Requirements

- Neovim >= 0.9.0
- Git
- A Nerd Font (for icons)
- ripgrep (for grep functionality)
- Node.js (for some LSP servers)
- Python 3 with pip (for Python development)

## Installation

1. Backup your existing configuration:
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

2. Clone this repository:
```bash
git clone <your-repo-url> ~/.config/nvim
```

3. Start Neovim:
```bash
nvim
```

Lazy.nvim will automatically install all plugins on first launch.

## Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── nvim-keys.lua          # Global keybindings
│   ├── autocmds.lua           # Auto-commands
│   ├── setup/
│   │   ├── lazy.lua           # Plugin manager setup
│   │   └── options.lua        # Vim options
│   └── plugins/               # Plugin specifications
│       ├── ai.lua             # AI coding assistants
│       ├── coding.lua         # Completion & editing
│       ├── colorschemes.lua   # Color schemes
│       ├── debug.lua          # Debugging tools
│       ├── editor.lua         # Editor enhancements
│       ├── lsp.lua            # LSP configuration
│       ├── tools.lua          # Additional tools
│       ├── ui.lua             # UI enhancements
│       ├── versioning.lua     # Git integration
│       └── languages/         # Language-specific plugins
├── ftplugin/                  # Filetype configurations
├── after/ftdetect/            # Custom filetype detection
└── snippets/                  # Custom snippets
```

## Key Plugins

### AI & Coding Assistance

- **Sidekick.nvim** - AI-powered coding assistant with Claude integration
- **Blink.cmp** - Modern completion engine with LSP, Copilot, and snippets
- **nvim-autopairs** - Auto-close brackets and quotes
- **nvim-surround** - Manipulate surrounding characters

### Editor Enhancements

- **Snacks.nvim** - Collection of utilities (fuzzy finder, explorer, git, terminal, etc.)
- **Spelunk.nvim** - Code navigation and bookmarking
- **Peek.nvim** - Live Markdown preview
- **Which-Key** - Keybinding hints

### LSP & Language Support

- **Mason.nvim** - LSP/tool installer
- **nvim-treesitter** - Syntax highlighting and code understanding
- **Conform.nvim** - Code formatting
- **nvim-lint** - Linting framework

### UI Enhancements

- **Lualine** - Beautiful statusline
- **Noice.nvim** - Enhanced UI for messages and popups
- **Bufferline** - Buffer tabs with icons
- **Dropbar.nvim** - Breadcrumb navigation
- **Neominimap** - Code minimap (VSCode-style)
- **Rainbow Delimiters** - Colorful bracket pairs

### Git Integration

- **LazyGit.nvim** - Terminal UI for git
- **Gitsigns** - Git decorations and inline blame
- **gh.nvim** - GitHub integration
- **git-conflict.nvim** - Merge conflict resolution

### Additional Tools

- **Yazi.nvim** - Modern file manager integration
- **Obsidian.nvim** - Note-taking integration
- **ToggleTerm** - Terminal management
- **Wakatime** - Time tracking

## Language Support

Configured support for:

- **Python** - Full LSP, debugging (DAP), testing (Neotest), formatting (ruff), linting (ruff)
- **JavaScript/TypeScript** - LSP, formatting (prettier), linting (eslint)
- **Lua** - LSP with Neovim-specific enhancements
- **Markdown** - Live preview, enhanced editing
- **HTML/CSS** - LSP, formatting
- **Vue.js** - Treesitter support
- **PHP** - LSP, linting
- **Elixir** - Smart indentation
- **ReasonML/Rescript** - Custom parser, syntax highlighting
- **Groovy** - Syntax support
- **Jinja** - Template support
- **YAML** - Docker-compose detection
- **JSON** - Formatting (jq)
- **XML** - Syntax support
- **Nix** - Syntax support
- **Shell** - Syntax support

## Keybindings

Leader key: `,` (comma)

### General

| Key                 | Action                        |
|---------------------|-------------------------------|
| `<C-y>`             | Toggle search highlighting    |
| `<leader>q`         | Quit                          |
| `<leader><leader>`  | Escape (works in most modes)  |

### Buffers & Tabs

| Key                 | Action               |
|---------------------|----------------------|
| `<S-h>` / `<S-l>`   | Previous/Next buffer |
| `<S-d>`             | Close buffer         |
| `<leader>bd`        | Delete buffer        |
| `<A-h>` / `<A-l>`   | Previous/Next tab    |
| `<leader>tn`        | New tab              |
| `<leader>tc`        | Close tab            |

### Files & Search

| Key               | Action            |
|-------------------|-------------------|
| `<leader><space>` | Smart file finder |
| `<leader>,`       | Buffer picker     |
| `<leader>/`       | Live grep         |
| `<leader>e`       | File explorer     |
| `<leader>ff`      | Find files        |
| `<leader>fg`      | Git files         |
| `<leader>fr`      | Recent files      |

### LSP

| Key          | Action               |
|--------------|----------------------|
| `<leader>h`  | Hover documentation  |
| `<leader>ca` | Code actions         |
| `<leader>rn` | Rename symbol        |
| `<leader>cf` | Format buffer        |
| `gd`         | Go to definition     |
| `gD`         | Go to declaration    |
| `gr`         | References           |
| `gI`         | Go to implementation |
| `gy`         | Go to type definition|

### Git

| Key           | Action                        |
|---------------|-------------------------------|
| `<leader>gg`  | LazyGit                       |
| `<leader>gb`  | Git branches                  |
| `<leader>gl`  | Git log                       |
| `<leader>gs`  | Git status                    |
| `<leader>gf`  | Git log (current file)        |
| `<leader>gbl` | Git blame line                |
| `<leader>gB`  | Git browse (open in browser)  |

### AI Assistant

| Key          | Action                |
|--------------|-----------------------|
| `<leader>aa` | Toggle Sidekick CLI   |
| `<leader>as` | Select CLI tool       |
| `<leader>at` | Send current context  |
| `<leader>av` | Send visual selection |
| `<leader>ac` | Toggle Claude         |
| `<c-.>`      | Switch focus to AI    |

### Testing & Debugging

| Key          | Action                             |
|--------------|------------------------------------|
| `<leader>tr` | Run test                           |
| `<leader>to` | Open test output                   |
| `<leader>ts` | Toggle test summary                |
| `,v`         | Select Python virtual environment  |

### Terminal

| Key          | Action             |
|--------------|--------------------|
| `<c-/>`      | Toggle terminal    |
| `<leader>tt` | Toggle terminal    |
| `<ESC><ESC>` | Exit terminal mode |

### Additional Features

| Key          | Action                        |
|--------------|-------------------------------|
| `<leader>z`  | Zen mode                      |
| `<leader>.`  | Scratch buffer                |
| `<leader>n`  | Notification history          |
| `<leader>xx` | Toggle diagnostics (Trouble)  |
| `<leader>-`  | Open Yazi at current file     |
| `<leader>os` | Search Obsidian notes         |
| `<leader>on` | New Obsidian note             |

Full keybinding reference available via `<leader>` (shows Which-Key menu after 300ms).

## Configuration

### Options

Key configurations in `lua/setup/options.lua`:

- Line numbers enabled
- Smart case-insensitive search
- System clipboard integration
- True color support
- Global statusline
- Mouse support enabled
- Word wrap enabled

### Color Scheme

Default: **Catppuccin Mocha**

Available themes:
- Catppuccin (current)
- Kanagawa
- Tokyo Night
- Rose Pine
- Moonfly
- OneDark
- Nordic
- And more...

Change theme by editing `lua/plugins/colorschemes.lua`.

## Customization

### Adding Plugins

Add new plugin specifications in the appropriate category file under `lua/plugins/`:

```lua
return {
  "author/plugin-name",
  event = "VeryLazy",  -- Lazy load
  config = function()
    -- Plugin configuration
  end,
}
```

### Language-Specific Settings

Add or modify filetype settings in `ftplugin/<language>.lua`:

```lua
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
-- Additional settings
```

### Keybindings

Add custom keybindings in `lua/nvim-keys.lua` or within plugin configurations.

## Tools Installation

The configuration uses **Ensure.nvim** to automatically install required tools:

### Formatters
- stylua (Lua)
- ruff_format (Python)
- prettier (JavaScript/TypeScript)

### Linters
- ruff (Python)
- eslint (JavaScript/TypeScript)
- codespell (General)

### Additional Tools
- Treesitter parsers (auto-installed as needed)
- LSP servers (installed via Mason)
- DAP adapters (Python debugpy)

## Python Development

This configuration includes comprehensive Python support:

1. **LSP**: Auto-completion, go-to-definition, hover documentation
2. **Formatting**: ruff_format with organize imports
3. **Linting**: ruff for fast Python linting
4. **Testing**: Neotest with Python adapter (uses "eb" runner)
5. **Debugging**: nvim-dap-python with debugpy
6. **Virtual Environments**: venv-selector for easy switching (`,v`)

## Obsidian Integration

Configured for note-taking at `~/Documents/rcommande`:

- Search notes: `<leader>os`
- New note: `<leader>on`
- Quick switch: `<leader>oqs`
- Daily note: `<leader>otd`

Configure your vault path in `lua/plugins/tools.lua`.

## Tips

1. **First Time Setup**: Let all plugins install, then restart Neovim
2. **LSP Servers**: Use `:Mason` to install language servers
3. **Treesitter**: Parsers install automatically when opening files
4. **Which-Key**: Press `<leader>` and wait to see available keybindings
5. **Health Check**: Run `:checkhealth` to diagnose issues
6. **Updates**: Run `:Lazy update` to update all plugins

## Troubleshooting

### Plugins not loading
```vim
:Lazy sync
```

### LSP not working
```vim
:LspInfo
:Mason
```

### Treesitter issues
```vim
:TSUpdate
:TSInstall <language>
```

### Python debugging not working
Ensure debugpy is installed:
```bash
pip install debugpy
```

## Contributing

Feel free to customize this configuration to your needs. Each plugin is well-documented in its respective file under `lua/plugins/`.

## License

MIT

## Acknowledgments

Built with:
- [Neovim](https://neovim.io/)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)
- And many amazing plugin authors

---

**Maintained by**: Romain
**Last Updated**: February 2026
