# myvimrc

Vim設定ファイル (dpp.vim使用)

## 必要条件

- Vim 9.1+
- Deno 2.0+
- Git

## インストール

```bash
# リポジトリをクローン
git clone https://github.com/YOUR_USERNAME/myvimrc ~/myvimrc

# シンボリックリンクを作成
cd ~/myvimrc && ./install.sh

# dppコアコンポーネントをセットアップ
~/.vim/bin/dpp-setup

# Vimを起動 (状態が自動構築される)
vim

# プラグインをインストール
:DppInstall
```

## ファイル構成

```
myvimrc/
├── vimrc              # メイン設定 (~/.vimrc にリンク)
├── rc/
│   ├── dpp.toml       # 即時読み込みプラグイン
│   ├── dpp_lazy.toml  # 遅延読み込みプラグイン
│   ├── dpp.ts         # dpp設定 (TypeScript)
│   └── PLUGINS.md     # プラグイン一覧
├── bin/
│   ├── dpp-setup      # 初期セットアップ
│   └── dpp-update     # プラグイン更新
├── install.sh         # インストーラー
└── README.md
```

## 主なキーマッピング

| キー | 機能 |
|------|------|
| `sf` | NERDTree切替 |
| `Ctrl+p` | ファイル検索 (fzf) |
| `\b` | バッファ一覧 |
| `\g` | Grep検索 |
| `F2` | シンボルビューア (Vista) |
| `gd` | 定義ジャンプ (LSP) |
| `gr` | 参照検索 (LSP) |
| `K` | ドキュメント表示 |
| `F3` | リネーム (LSP) |

## コマンド

| コマンド | 説明 |
|---------|------|
| `:DppInstall` | 未インストールプラグインをインストール |
| `:DppUpdate` | 全プラグインを更新 |
| `:PluginList` | プラグイン一覧を表示 |
| `:PluginStatus` | 読み込み済みプラグイン数を表示 |
| `:LspInstallServer` | 現在のファイルタイプ用LSPをインストール |

## 更新

```bash
# Vim外から更新
~/.vim/bin/dpp-update

# Vim内から更新
:DppUpdate
```
