# AGENTS.md — Neovim Configuration

Instructions pour les agents IA qui travaillent sur ce dépôt.

## Vue d'ensemble

Configuration Neovim moderne de Romain, écrite en **Lua**, gérée via **Lazy.nvim**.
Le repo contient uniquement de la configuration Neovim : pas de tests, pas de build system externe.

## Structure du projet

```
~/.config/nvim/
├── init.lua                    # Point d'entrée (3 lignes, minimaliste)
├── lua/
│   ├── nvim-keys.lua           # Keybindings globaux
│   ├── autocmds.lua            # Auto-commandes
│   ├── setup/
│   │   ├── lazy.lua            # Configuration du plugin manager
│   │   └── options.lua         # Options Vim globales
│   └── plugins/                # Spécifications des plugins
│       ├── ai.lua              # Sidekick.nvim (Claude/Copilot)
│       ├── coding.lua          # Complétion (Blink.cmp), autopairs, surround
│       ├── colorschemes.lua    # Thèmes (Catppuccin Mocha par défaut)
│       ├── debug.lua           # DAP (Python), Neotest
│       ├── editor.lua          # Snacks.nvim, Spelunk, bookmarks
│       ├── lsp.lua             # Mason, Treesitter, Conform, nvim-lint, ensure.nvim
│       ├── tools.lua           # Yazi, Obsidian, Wakatime, etc.
│       ├── ui.lua              # Lualine, Noice, Bufferline, etc.
│       ├── versioning.lua      # LazyGit, Gitsigns, gh.nvim, jj-diffconflicts
│       └── languages/          # Plugins spécifiques aux langages
├── ftplugin/                   # Configurations par filetype (18 langages)
├── after/ftdetect/             # Détection de filetypes personnalisés
└── snippets/                   # Snippets personnalisés
```

## Commandes utiles dans Neovim

Il n'y a pas de commandes de build/test/lint au sens traditionnel.
Les "commandes" sont des commandes Neovim :

```vim
" Gestion des plugins
:Lazy sync          " Installer/mettre à jour tous les plugins
:Lazy update        " Mettre à jour les plugins
:Lazy clean         " Supprimer les plugins inutilisés

" LSP / Outils
:Mason              " Gérer les LSP servers, linters, formatters
:LspInfo            " Statut du LSP actif
:checkhealth        " Diagnostic global de l'installation

" Treesitter
:TSUpdate           " Mettre à jour les parsers
:TSInstall <lang>   " Installer un parser pour un langage

" Formatage
:lua require("conform").format()   " Formater le buffer courant
" Ou via le keymap : <leader>cf
```

## Style de code Lua

### Conventions générales

- **Indentation** : 2 espaces (tabs dans les fichiers Lua, expandtab activé)
- **Formateur** : `stylua` — lancer via `<leader>cf` ou `:lua require("conform").format()`
- **Quotes** : doubles guillemets `"` pour les strings (convention stylua)
- **Semicolons** : absents — ne pas en ajouter

### Structure des fichiers plugin

Chaque fichier dans `lua/plugins/` retourne une table Lazy.nvim :

```lua
return {
  {
    "author/plugin-name",
    event = "VeryLazy",    -- chargement lazy
    dependencies = { ... },
    opts = { ... },        -- préférer opts= à config= quand possible
    config = function()
      require("plugin").setup({ ... })
      -- keymaps ici si liés au plugin
      vim.keymap.set("n", "<leader>xx", function()
        -- action
      end, { noremap = true, silent = true, desc = "Description claire" })
    end,
  },
}
```

### Keybindings

- **Leader key** : `,` (virgule)
- Toujours inclure `{ noremap = true, silent = true }` pour les keymaps
- Toujours inclure `desc = "..."` pour la compatibilité Which-Key
- Utiliser `vim.keymap.set()` plutôt que `vim.api.nvim_set_keymap()`

```lua
-- ✅ Bon
vim.keymap.set("n", "<leader>xx", function()
  do_something()
end, { noremap = true, silent = true, desc = "Do something" })

-- ❌ Éviter
vim.api.nvim_set_keymap("n", "<leader>xx", ":DoSomething<CR>", { noremap = true })
```

### Configurations filetype (`ftplugin/`)

Utiliser `vim.opt_local` pour les options spécifiques à un filetype :

```lua
-- ftplugin/example.lua
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
```

### Autocommandes

Utiliser l'API Lua moderne :

```lua
vim.api.nvim_create_autocmd("FileType", {
  desc = "Description de l'autocmd",
  group = vim.api.nvim_create_augroup("nom_unique", {}),
  pattern = { "lua", "python" },
  callback = function()
    -- action
  end,
})
```

## Formatters & Linters configurés

Gérés via `ensure.nvim` (`lua/plugins/lsp.lua`) :

| Langage          | Formatter                          | Linter  |
| ---------------- | ---------------------------------- | ------- |
| Lua              | stylua                             | —       |
| Python           | ruff_format + ruff_organize_import | ruff    |
| JavaScript       | prettier                           | eslint  |
| JSON             | jq                                 | —       |
| Tous             | —                                  | codespell |

## Tests Python (Neotest)

Les tests Python sont lancés via **Neotest** avec le runner `eb` (outil custom de Romain) :

```vim
<leader>tr   " Lancer le test sous le curseur
<leader>to   " Ouvrir la sortie du test
<leader>ts   " Toggle le résumé des tests
<leader>top  " Toggle le panneau de sortie
```

Le runner est configuré dans `lua/plugins/debug.lua` :
```lua
require("neotest-python")({ runner = "eb", args = { "test" } })
```

## Débogage Python (DAP)

Utilise `nvim-dap-python` avec `debugpy` :
- `debugpy` est installé via Mason : `~/.local/share/nvim/mason/packages/debugpy/venv/bin/python`
- Sélection du venv Python : `,v` (VenvSelector)

## Environnement requis

- Neovim >= 0.9.0
- Git
- Nerd Font (pour les icônes)
- `ripgrep` (grep intégré : `rg --vimgrep --smart-case --hidden`)
- Node.js (LSP servers)
- Python 3 + pip + `debugpy`
- `deno` (pour peek.nvim — preview Markdown)
- `tree-sitter-cli` >= 0.26.1 (via `npm install -g tree-sitter-cli@0.26.1`)

> ⚠️ `tree-sitter-cli` n'est pas encore à la version 0.26.1 dans Nixpkgs.
> L'installer globalement via npm : `npm install -g tree-sitter-cli@0.26.1`

## Règles pour les agents

### Ne jamais commiter automatiquement

**RÈGLE ABSOLUE** : Ne JAMAIS créer de commits ou pusher sans demande explicite de Romain.
Romain utilise **jujutsu** (`jj`) en local, pas git directement.

### Modifications à éviter

- Ne pas modifier `lazy-lock.json` manuellement
- Ne pas toucher aux options globales dans `lua/setup/options.lua` sans vérification
- Ne pas changer le leader key (`,`) sans confirmation explicite

### Checklist avant toute modification

1. Lire le fichier cible en entier avant de le modifier
2. Vérifier qu'il n'y a pas déjà un plugin similaire dans le repo
3. Respecter le style stylua (2 espaces, double quotes)
4. Ajouter `desc = "..."` à tous les nouveaux keymaps
5. Lazy-loader les plugins quand c'est possible (`event`, `ft`, `cmd`, `keys`)
