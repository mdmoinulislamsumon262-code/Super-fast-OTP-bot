# Telegram Number + Temp Mail Bot — Railway Ready

এই package-টি Railway ওয়েবসাইটে deploy করার জন্য সম্পূর্ণ প্রস্তুত। এতে Number/OTP panel এবং Mail.gw Temp Mail system দুটোই আছে।

## Package-এ যা আছে

- `main.py` — সম্পূর্ণ bot source code
- `requirements.txt` — Python dependencies
- `Procfile` — Railway start command
- `railway.json` — Railway build/deploy/health-check configuration
- `run.sh` — alternative start script
- `.env.example` — required variables-এর নমুনা
- `.gitignore` — secret/database ignore rules
- `runtime.txt` — Python runtime

## এই সংস্করণের গুরুত্বপূর্ণ fixes

- ZebraSMS এখন `Get Number` এবং `View Range`-এর primary source। Zebra থেকে
  usable number না এলে তবেই অন্য enabled panel fallback হিসেবে চেষ্টা হবে।
- Zebra-এর বিভিন্ন response shape, endpoint এবং authentication-header
  variation handle করা হয়েছে।
- Auto SMS এখন প্রতিটি enabled panel-এর জন্য background poller দিয়ে চলবে,
  Telegram send ব্যর্থ হলে retry করবে, এবং SQLite ledger-এর কারণে restart-এর
  পর duplicate SMS পাঠাবে না।
- Admin → Settings → Others Link-এ `Main Channel` যোগ হয়েছে। Forwarded OTP
  card-এ `GO TO PANEL` এবং configured `GO TO CHANNEL` button দেখা যাবে।

Auto SMS-এর জন্য bot-কে target group/channel-এ admin করা এবং numeric chat ID
সঠিকভাবে সেট করা আবশ্যক। ZebraSMS-এর API response যদি সম্পূর্ণ আলাদা হয়,
Railway logs-এ `ZebraSMS ... raw=` line দেখে panel-এর official endpoint/body
অনুযায়ী `ZEBRA_*_PATHS` adjust করতে হবে।

## Railway-তে deploy করার ধাপ

### ধাপ ১: ZIP প্রস্তুত করুন

1. এই ZIP download করুন।
2. আপনার computer-এ ZIP extract করুন।
3. Extract করা folder-এর ভেতরের সব file রাখুন; `main.py` অবশ্যই root folder-এ থাকতে হবে।

### ধাপ ২: GitHub-এ upload করুন

1. GitHub-এ নতুন একটি **Private repository** তৈরি করুন।
2. Extract করা সব file repository-তে upload করুন।
3. `.env.example` রাখবেন, কিন্তু কোনো real token বা password upload করবেন না।

### ধাপ ৩: Railway project তৈরি করুন

1. Railway dashboard খুলুন।
2. **New Project** নির্বাচন করুন।
3. **Deploy from GitHub Repo** নির্বাচন করুন।
4. আপনার repository select করুন।
5. Railway automatic build শেষ হওয়া পর্যন্ত অপেক্ষা করুন।

### ধাপ ৪: Railway Variables দিন

Railway service-এর **Variables** section-এ এগুলো দিন:

```text
BOT_TOKEN=আপনার Telegram bot token
ADMIN_ID=আপনার numeric Telegram user ID
DATA_DIR=/data
```

### ধাপ ৫: Persistent Volume যোগ করুন

1. Railway service-এর **Volumes** section খুলুন।
2. নতুন Volume তৈরি করুন।
3. Mount path দিন:

```text
/data
```

এতে SQLite database এবং Temp Mail state restart/redeploy-এর পরেও থাকবে।

### ধাপ ৬: Deploy এবং public domain

1. **Deploy** চাপুন।
2. Deploy সফল হলে **Settings → Networking** খুলুন।
3. **Generate Domain** চাপুন।
4. Railway health check `/health` path ব্যবহার করবে।

### ধাপ ৭: Bot test করুন

Telegram-এ bot খুলে পাঠান:

```text
/start
```

Temp Mail চালু করতে:

- মেনুর `📧 Temp Mail` button চাপুন, অথবা
- `/tempmail` পাঠান

Mail manually check করতে:

```text
/checkmail
```

## Temp Mail কীভাবে কাজ করে

- Mail.gw থেকে domain নেওয়া হয়
- নতুন email account এবং password তৈরি হয়
- token সংগ্রহ করা হয়
- প্রতি ১০ সেকেন্ডে নতুন mail চেক হয়
- একই message ID দ্বিতীয়বার পাঠানো হয় না
- email, password, token এবং seen message ID JSON state-এ রাখা হয়
- দুই ঘণ্টা পর পুরনো mailbox state মুছে যায়
- mail body কখনো bot-এ দেখানো হয় না; শুধু sender, subject এবং OTP দেখানো হয়

## জরুরি নিরাপত্তা

- `BOT_TOKEN` কখনো GitHub, screenshot বা public chat-এ দেবেন না।
- Real `.env` file upload করবেন না।
- Railway Variables-এই secret values রাখবেন।
- Repository private রাখাই নিরাপদ।
