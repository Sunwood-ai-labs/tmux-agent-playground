#!/bin/bash
# 実験テンプレート生成スクリプト
# 使い方: ./scripts/create-experiment.sh <experiment-name> [agent-count]

set -e

# 色の定義
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ルートディレクトリ
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATE_DIR="$ROOT_DIR/templates/experiment"
EXPERIMENTS_DIR="$ROOT_DIR/experiments"

# ヘルプメッセージ
show_help() {
  cat << EOF
${BLUE}_experiment_    実験名（ハイフン区切り、例: code-review-3agents）
  [agent-count] エージェント数（デフォルト: 3）

${YELLOW}例:${NC}
  $ ./scripts/create-experiment.sh code-review-3agents 3
  $ ./scripts/create-experiment.sh parallel-refactor-5agents 5

EOF
}

# 引数チェック
if [ $# -lt 1 ]; then
  show_help
  exit 1
fi

EXPERIMENT_NAME="$1"
AGENT_COUNT="${2:-3}"
DATE=$(date +"%Y-%m-%d")

# 実験IDを生成（experiment-001形式）
EXPERIMENT_ID="experiment-$(printf "%03d" $(ls -1 "$EXPERIMENTS_DIR" 2>/dev/null | wc -l))"

# 実験名をスネークケースから読みやすい形式に変換
DISPLAY_NAME=$(echo "$EXPERIMENT_NAME" | sed 's/-/ /g' | sed 's/\b\w/\u&/g')

# 実験ディレクトリを作成
EXPERIMENT_DIR="$EXPERIMENTS_DIR/$EXPERIMENT_ID-$EXPERIMENT_NAME"
mkdir -p "$EXPERIMENT_DIR/results"

echo -e "${BLUE}Creating new experiment: ${EXPERIMENT_ID}${NC}"
echo "  Name: $DISPLAY_NAME"
echo "  Agent count: $AGENT_COUNT"
echo "  Directory: $EXPERIMENT_DIR"
echo ""

# テンプレートファイルのパス
SETUP_TEMPLATE="$TEMPLATE_DIR/setup.sh.template"
RUN_TEMPLATE="$TEMPLATE_DIR/run.sh.template"
README_TEMPLATE="$TEMPLATE_DIR/README.md.template"

# setup.shを生成
echo -e "${GREEN}→${NC} Generating setup.sh..."
sed -e "s/{EXPERIMENT_ID}/$EXPERIMENT_ID/g" \
    -e "s/{EXPERIMENT_NAME}/$DISPLAY_NAME/g" \
    -e "s/{AGENT_COUNT}/$AGENT_COUNT/g" \
    "$SETUP_TEMPLATE" > "$EXPERIMENT_DIR/setup.sh"
chmod +x "$EXPERIMENT_DIR/setup.sh"

# run.shを生成
echo -e "${GREEN}→${NC} Generating run.sh..."
sed -e "s/{EXPERIMENT_ID}/$EXPERIMENT_ID/g" \
    -e "s/{EXPERIMENT_NAME}/$DISPLAY_NAME/g" \
    -e "s/{AGENT_COUNT}/$AGENT_COUNT/g" \
    -e "s/{TASK_AGENT_1}/\"タスクをここに記述\"/g" \
    -e "s/{TASK_AGENT_2}/\"タスクをここに記述\"/g" \
    "$RUN_TEMPLATE" > "$EXPERIMENT_DIR/run.sh"
chmod +x "$EXPERIMENT_DIR/run.sh"

# README.mdを生成
echo -e "${GREEN}→${NC} Generating README.md..."
sed -e "s/{EXPERIMENT_ID}/$EXPERIMENT_ID/g" \
    -e "s/{EXPERIMENT_NAME}/$DISPLAY_NAME/g" \
    -e "s/{AGENT_COUNT}/$AGENT_COUNT/g" \
    -e "s/{DATE}/$DATE/g" \
    -e "s/{DESCRIPTION}/実験の説明をここに記述/g" \
    -e "s/{PURPOSE}/実験の目的をここに記述/g" \
    -e "s/{NOTES}/実験に関するメモをここに記述/g" \
    "$README_TEMPLATE" > "$EXPERIMENT_DIR/README.md"

# 完了メッセージ
echo ""
echo -e "${GREEN}✅ Experiment created successfully!${NC}"
echo ""
echo "Directory structure:"
echo "  $EXPERIMENT_DIR/"
echo "    ├── setup.sh      # セットアップスクリプト（tmuxセッション作成）"
echo "    ├── run.sh        # 実行スクリプト（タスク送信）"
echo "    ├── README.md     # 実験の説明"
echo "    └── results/      # 成果物保存場所"
echo ""
echo "Next steps:"
echo -e "  ${YELLOW}1.${NC} Edit run.sh to define tasks for each agent"
echo -e "  ${YELLOW}2.${NC} Run: cd $EXPERIMENT_DIR && ./setup.sh"
echo -e "  ${YELLOW}3.${NC} Attach to tmux: tmux attach -t $EXPERIMENT_ID"
echo -e "  ${YELLOW}4.${NC} Start Claude Code in each pane"
echo -e "  ${YELLOW}5.${NC} Run: ./run.sh"
echo ""
