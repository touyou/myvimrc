#!/bin/bash
# myvimrc インストールスクリプト
# シンボリックリンクを作成して設定を有効化します
#
# 使い方:
#   git clone https://github.com/YOUR_USERNAME/myvimrc ~/myvimrc
#   cd ~/myvimrc && ./install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== myvimrc インストール ==="
echo "ソース: $SCRIPT_DIR"
echo ""

# バックアップと削除
backup_and_link() {
    local src="$1"
    local dest="$2"

    if [ -L "$dest" ]; then
        rm "$dest"
        echo "既存のシンボリックリンクを削除: $dest"
    elif [ -e "$dest" ]; then
        local backup="${dest}.backup.$(date +%Y%m%d%H%M%S)"
        mv "$dest" "$backup"
        echo "バックアップ作成: $backup"
    fi

    ln -s "$src" "$dest"
    echo "✓ $dest -> $src"
}

# ~/.vimrc
backup_and_link "$SCRIPT_DIR/vimrc" "$HOME/.vimrc"

# ~/.vim/rc ディレクトリ
mkdir -p "$HOME/.vim"
backup_and_link "$SCRIPT_DIR/rc" "$HOME/.vim/rc"

# ~/.vim/bin ディレクトリ
backup_and_link "$SCRIPT_DIR/bin" "$HOME/.vim/bin"

# ~/.vim/tmp ディレクトリ (スワップファイル用)
mkdir -p "$HOME/.vim/tmp"

echo ""
echo "=== インストール完了 ==="
echo ""
echo "次のステップ:"
echo "  1. ~/.vim/bin/dpp-setup  # dppコアをクローン"
echo "  2. vim                    # 起動して状態構築"
echo "  3. :DppInstall            # プラグインインストール"
