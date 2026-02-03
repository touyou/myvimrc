# dpp.vim Plugin List

Last updated: 2026-02-01

## Immediate Load (dpp.toml)

| Plugin | Description |
|--------|-------------|
| ryanoasis/vim-devicons | File icons |
| scrooloose/nerdtree | File tree explorer |
| wadackel/vim-dogrun | Color scheme |
| junegunn/fzf | Fuzzy finder core |
| junegunn/fzf.vim | Fuzzy finder vim integration |
| liuchengxu/vista.vim | LSP symbol viewer |
| tpope/vim-fugitive | Git integration |
| prabirshrestha/async.vim | Async library |
| prabirshrestha/vim-lsp | LSP client |
| mattn/vim-lsp-settings | Auto LSP server install |
| prabirshrestha/asyncomplete.vim | Completion framework |
| prabirshrestha/asyncomplete-lsp.vim | LSP completion source |
| fatih/vim-go | Go support |
| leafgarland/typescript-vim | TypeScript syntax |
| neovimhaskell/haskell-vim | Haskell syntax |
| udalov/kotlin-vim | Kotlin syntax |
| dart-lang/dart-vim-plugin | Dart support |

## Lazy Load (dpp_lazy.toml)

| Plugin | Trigger | Description |
|--------|---------|-------------|
| toyamarinyon/vim-swift | `on_ft: swift` | Swift syntax |
| cespare/vim-toml | `on_ft: toml` | TOML syntax |
| rust-lang/rust.vim | `on_ft: rust` | Rust support |

## Plugin Management Commands

| Command | Description |
|---------|-------------|
| `:DppInstall` | Install missing plugins (shows progress) |
| `:DppUpdate` | Update all plugins |
| `:PluginList` | Open this file |
| `:PluginStatus` | Show loaded plugin count |

## Key Mappings

| Key | Action |
|-----|--------|
| `sf` | Toggle NERDTree |
| `Ctrl+p` | File search (fzf) |
| `\b` | Buffer list |
| `\g` | Grep search |
| `\h` | Recent files |
| `F2` | Toggle Vista (symbols) |
| `gd` | Go to definition (LSP) |
| `gr` | Find references (LSP) |
| `K` | Show documentation (LSP) |
| `F3` | Rename symbol (LSP) |

## LSP Servers

Install with `:LspInstallServer` when opening a file of each type.

| Language | Server |
|----------|--------|
| TypeScript/JS | typescript-language-server |
| Python | pylsp / pyright |
| Go | gopls |
| Rust | rust-analyzer |
| Swift | sourcekit-lsp |
| Haskell | haskell-language-server (ghcup経由で自動検出) |
| Kotlin | kotlin-language-server |
| Dart | dart language-server |

## Haskell環境

**インストール済みツール:**
- GHC 9.6.7
- HLS 2.13.0.0
- Cabal 3.16.1.0

**機能:**
- 保存時自動フォーマット
- 型情報表示 (K)
- 定義ジャンプ (gd)
- 参照検索 (gr)
- リネーム (F3)

**更新:** `ghcup tui` でGUI管理
