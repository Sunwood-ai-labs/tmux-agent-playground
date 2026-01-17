<div align="center">

<img src="assets/header.svg" alt="tmux-agent-playground Header" width="800"/>

</div>

<div align="center">

### tmuxセッションで複数のClaude Codeエージェントを協調させるプレイグラウンド

[![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](LICENSE)
[![GitHub](https://img.shields.io/badge/GitHub-View-success?style=flat-square&logo=github)](https://github.com/Sunwood-ai-labs/tmux-agent-playground)

Claude Codeの複数のエージェントをtmuxセッション内で並行実行し、
分散処理や協調タスクを実験するためのプレイグラウンド環境。

</div>

---

## 概要

`tmux-agent-playground` は、tmuxのマルチペイン機能を使って複数のClaude Codeエージェントを同時に実行し、相互に協調させる実験場です。

各エージェント（部下）に独立したタスクを割り当てたり、協調して大きな問題を解決させたりすることができます。

---

## 特徴

<div align="center">

| 機能 | 説明 |
|:------:|------|
| **マルチエージェント実行** | tmuxセッションで複数のClaude Codeを並行実行 |
| **ペイン操作API** | `tmux send-keys`で各エージェントに指示を送信 |
| **状態監視** | `tmux capture-pane`で各エージェントの状態を確認 |
| **協調タスク** | エージェント同士で連携したタスク実行が可能 |

</div>

---

## セットアップ

### 要件

- tmux
- GitHub CLI (`gh`)
- Claude Code

### インストール

1. リポジトリをクローン

```bash
git clone https://github.com/Sunwood-ai-labs/tmux-agent-playground.git
cd tmux-agent-playground
```

2. tmuxセッションを起動

```bash
# 3ペイン分割でセッションを作成
tmux new-session -d -s dev -n main
tmux split-window -h -t dev:0
tmux split-window -v -t dev:0.1

# 各ペインでClaude Codeを起動（手動で実行）
tmux attach -t dev
```

---

## 構造

```
tmux-agent-playground/
├── experiments/      # 実験フォルダ（各実験のスクリプトと成果物）
│   ├── experiment-001-code-review-3agents/
│   │   ├── setup.sh        # tmuxセッション作成スクリプト
│   │   ├── run.sh          # タスク送信スクリプト
│   │   ├── README.md       # 実験の説明
│   │   └── results/        # 成果物保存場所
│   └── experiment-002-parallel-refactor-5agents/
│       └── ...
├── scripts/          # ユーティリティスクリプト
│   ├── create-experiment.sh  # 実験テンプレート生成スクリプト
│   └── tmux-agents-guide.md  # エージェント操作ガイド
├── templates/        # 実験テンプレート
│   └── experiment/
│       ├── setup.sh.template
│       ├── run.sh.template
│       └── README.md.template
├── assets/           # 画像等のリソース
│   └── header.svg    # ヘッダー画像
├── README.md
└── LICENSE
```

---

## 使用法

### 基本的な使い方

```bash
# セッション確認
tmux list-sessions

# ペイン確認
tmux list-panes -t dev -F "#{pane_pid} #{pane_current_command}"

# ペイン1（部下A）に指示を送る
tmux send-keys -t dev:0.1 "こんにちは！" Enter

# 応答を確認
tmux capture-pane -t dev:0.1 -p -S -50
```

### 詳細な使い方

詳細な操作方法は [scripts/tmux-agents-guide.md](scripts/tmux-agents-guide.md) を参照してください。

---

## 実験の作成と実行

`create-experiment.sh` スクリプトを使って、新しい実験を簡単に作成できます。

### 新しい実験を作成

```bash
# 実験名とエージェント数を指定
./scripts/create-experiment.sh <experiment-name> [agent-count]

# 例: 3エージェントでコードレビュー実験を作成
./scripts/create-experiment.sh code-review-3agents 3

# 例: 5エージェントで並列リファクタリング実験を作成
./scripts/create-experiment.sh parallel-refactor-5agents 5
```

### 実験を実行

```bash
# 作成された実験ディレクトリに移動
cd experiments/experiment-001-code-review-3agents

# 1. tmuxセッションを作成
./setup.sh

# 2. tmuxセッションにアタッチして、各ペインでClaude Codeを起動
tmux attach -t experiment-001
# 各ペインで: ccode

# 3. セッションからデタッチ（Ctrl+b, d）
# 4. 各エージェントにタスクを送信
./run.sh

# 5. 進捗を確認
tmux attach -t experiment-001
```

### 実験結果

結果は `experiments/<experiment-id>/results/` ディレクトリに保存されます。

### 実験テンプレート

実験は以下のテンプレートから生成されます：

- `setup.sh` - tmuxセッションのレイアウト設定
- `run.sh` - 各エージェントへのタスク送信
- `README.md` - 実験の説明

必要に応じてカスタマイズして使用してください。

---

## エージェント協調のアイデア

- **コードレビュー**: エージェント1が実装、エージェント2がレビュー
- **テスト駆動開発**: エージェント1がテスト作成、エージェント2が実装
- **並列リファクタリング**: 複数のファイルを同時にリファクタリング
- **競合解消**: マージコンフリクトを各エージェントが解決

---

## 謝辞

- [Claude Code](https://claude.ai/code) - Anthropic
- [tmux](https://github.com/tmux/tmux) - ターミナルマルチプレクサ

---

<div align="center">

Made with ❤️ by [Sunwood-ai-labs](https://github.com/Sunwood-ai-labs)

</div>
