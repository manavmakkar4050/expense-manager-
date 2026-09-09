# Factory Construction Expense Tracker — Setup

This is now a cloud-backed version of your tracker: sign in once, and your
data (bills, vendors, payments) syncs automatically between your phone and
laptop through Supabase. No backend server to run — Supabase handles the
database and login, Vercel just serves the static page.

## 1. Create the Supabase project (5 min)

1. Go to https://supabase.com → **New project** (free tier is enough).
2. Once it's created, go to **Project Settings → API**. Copy:
   - **Project URL**
   - **anon public** key
3. Go to **SQL Editor → New query**, paste the contents of `schema.sql`
   (included alongside this file), and click **Run**. This creates the
   table that stores your bills/vendors and locks it down so only you can
   read/write your own data.
4. Go to **Authentication → Providers** and confirm **Email** is enabled
   (it is by default).
   - Optional but recommended: **Authentication → Settings → Email Auth**,
     turn **off** "Confirm email" if you want to sign in immediately after
     creating your account without checking your inbox first. You can
     leave it on for extra security if you prefer.

## 2. Connect the app to your project (1 min)

Open `index.html`, find this block near the top of the `<script>` section:

```js
const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
```

Replace both with the values you copied in step 1. The anon key is safe to
put in client-side code — it's public by design, and the row-level-security
policy from `schema.sql` is what actually protects your data.

## 3. Push to GitHub

```bash
cd factory-tracker
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/<your-username>/<repo-name>.git
git push -u origin main
```

(Create the empty repo on GitHub first if you haven't.)

## 4. Deploy on Vercel (2 min)

1. Go to https://vercel.com → **Add New → Project** → import the GitHub
   repo you just pushed.
2. Framework preset: choose **Other** (this is a plain static HTML file,
   no build step needed).
3. Click **Deploy**. Vercel gives you a live URL like
   `https://factory-tracker-yourname.vercel.app`.

## 5. Use it on your phone and laptop

- Open the Vercel URL on both devices.
- First time: click **Create an account**, enter an email + password.
- After that, sign in with the same email/password on the other device.
- Any bill you add, edit, or pay on one device pushes to Supabase and
  appears on the other device automatically (live, via Supabase Realtime —
  no refresh needed if both are open at once; otherwise it loads fresh
  data every time the page opens).
- On your phone, use "Add to Home Screen" (Safari) or "Install app"
  (Chrome) so it opens full-screen like a native app.

## Notes

- **Data location**: everything lives in your own Supabase Postgres
  database, in a table only your account can access.
- **Backups**: use the app's **Export CSV** button periodically, or take a
  snapshot from Supabase's dashboard (**Table Editor → app_state**) if you
  want a manual backup beyond the built-in cloud storage.
- **Cost**: Vercel's free tier and Supabase's free tier both comfortably
  cover single-user apps like this.
- **Security**: only you (the account you sign up with) can read or write
  your data — enforced by the row-level-security policy in `schema.sql`,
  not just the app's UI.
