# Telegram Number Bot

This package contains the Telegram bot with styled keyboard buttons and two-number allocation.

## Run locally

1. Install Python 3.11 or newer.
2. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

3. Set environment variables:

   ```bash
   export BOT_TOKEN="your_bot_token"
   export ADMIN_ID="your_telegram_user_id"
   ```

4. Start the bot:

   ```bash
   python main.py
   ```

   Or, after making the script executable:

   ```bash
   ./run.sh
   ```

The bot creates its SQLite database as `voltx.db`. Do not commit that database or your `.env` file.

## Deploy

This repository includes a `Procfile` for worker-based hosts and `render.yaml` for Render. Add `BOT_TOKEN` and `ADMIN_ID` as host environment variables before starting the worker.

## Changes included

- Buttons receive `success`, `danger`, or `primary` styles based on their action.
- Every successful number request allocates two distinct numbers.
- Both numbers are shown in separate copyable boxes in one Telegram message.
- OTP polling keeps a separate allocation record for each number.
- The bot token is read from `BOT_TOKEN`; no secret is included in this package.