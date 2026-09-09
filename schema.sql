-- Run this once in your Supabase project's SQL Editor
-- (Dashboard → SQL Editor → New query → paste → Run)

create table if not exists app_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  bills jsonb not null default '[]'::jsonb,
  vendors jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

alter table app_state enable row level security;

-- Each signed-in user can only read/write their own row
create policy "select own state" on app_state
  for select using (auth.uid() = user_id);

create policy "insert own state" on app_state
  for insert with check (auth.uid() = user_id);

create policy "update own state" on app_state
  for update using (auth.uid() = user_id);

-- Enable realtime updates for cross-device sync
alter publication supabase_realtime add table app_state;
