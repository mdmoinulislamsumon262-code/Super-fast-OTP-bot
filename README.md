# Telegram Number Bot — Railway Edition

এটি Railway web service হিসেবে চালানোর জন্য প্রস্তুত করা Telegram number/OTP bot।
বটের UI-তে `Powered by` নামের ডিফল্ট মান এখন **সুমন**।

## Railway-তে চালানোর নিয়ম

1. এই ZIP extract করে GitHub repository-তে push করুন অথবা Railway-তে source হিসেবে upload করুন।
2. Railway-তে **New Project → Deploy from GitHub repo** নির্বাচন করুন।
3. Service-এর **Variables**-এ নিচের দুইটি required variable যোগ করুন:

   | Variable | কী দিতে হবে |
   | --- | --- |
   | `BOT_TOKEN` | @BotFather থেকে পাওয়া Telegram bot token |
   | `ADMIN_ID` | আপনার numeric Telegram user ID |

4. SQLite database টিকিয়ে রাখতে Railway-তে একটি **Volume** যোগ করুন এবং mount path হিসেবে `/data` দিন। এরপর variable দিন:

   ```text
   DATA_DIR=/data
   ```

   Volume না দিলে bot চলবে, কিন্তু redeploy বা restart-এর পরে database হারিয়ে যেতে পারে।
5. Deploy করুন। `railway.json` এবং `Procfile` নিজে থেকেই `python main.py` চালাবে।
6. Railway health check `/health` path ব্যবহার করবে। এটি bot-এর polling-এর সঙ্গে একই web service-এ চালু থাকে।

## Local run

Python 3.11 বা নতুন version ব্যবহার করুন:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# .env-এ BOT_TOKEN ও ADMIN_ID বসান
set -a
source .env
set +a
python main.py
```

Windows-এ `.env` থেকে values নিয়ে environment variables হিসেবে সেট করে `python main.py` চালান।

## গুরুত্বপূর্ণ নিরাপত্তা নির্দেশনা

- কোনো token, API key বা password এই ZIP-এ রাখা হয়নি।
- আগের আপলোডের environment example-এ থাকা exposed bot token ইচ্ছাকৃতভাবে বাদ দেওয়া হয়েছে। যদি সেটি সত্যিকারের token হয়ে থাকে, @BotFather থেকে token revoke করে নতুন token ব্যবহার করুন।
- SMS panel API key-গুলো bot-এর admin panel থেকেই সেট করা যায়; সেগুলো source code-এ hard-code করা নেই।
- `voltx.db` ও `.env` Git-এ commit করা যাবে না।

## কী কী ঠিক করা হয়েছে

- ক্ষতিগ্রস্ত ZIP থেকে সব source file উদ্ধার করে নতুন valid ZIP তৈরি করা হয়েছে।
- duplicate imports এবং ভুল/নিরাপদ নয় এমন default credential সরানো হয়েছে।
- Railway web service-এর জন্য `PORT`-ভিত্তিক health server যোগ করা হয়েছে।
- `/`, `/health` এবং `/healthz` health response যোগ করা হয়েছে।
- Railway Volume-এর জন্য configurable `DATA_DIR` যোগ করা হয়েছে।
- database backup এবং restore এখন একই configured data directory ব্যবহার করে।
- `Powered by` default নাম **সুমন** করা হয়েছে।
- Railway deploy config, `.env.example`, `.gitignore`, Procfile এবং run instructions যোগ করা হয়েছে।