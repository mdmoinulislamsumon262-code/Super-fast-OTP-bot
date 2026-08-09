#!/usr/bin/env bash
set -euo pipefail

: "${BOT_TOKEN:?Set BOT_TOKEN before starting the bot}"
: "${ADMIN_ID:?Set ADMIN_ID before starting the bot}"

exec python main.py