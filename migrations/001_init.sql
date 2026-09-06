-- Supabase/Postgres migrations: enums, tables, RLS, triggers (based on project doc)

create type if not exists plant_status as enum ('healthy', 'attention', 'recovering');
create type if not exists event_type as enum (
  'water','fertilize','repot','prune','pest_treatment','new_leaf',
  'new_growth_point','flowering','pest_found','measurement','photo',
  'moved','substrate_changed','note'
);
create type if not exists pot_type as enum ('plastic','terracotta','ceramic','self_watering','net_pot','other');
create type if not exists subscription_tier as enum ('free','pro');

-- profiles
create table if not exists profiles (
  id uuid primary key,
  display_name text,
  subscription_tier subscription_tier default 'free',
  subscription_expires_at timestamptz,
  terms_accepted_at timestamptz,
  terms_version text
);

-- plants
create table if not exists plants (
  id uuid default gen_random_uuid() primary key,
  user_id uuid not null,
  botanical_name text,
  cultivar text,
  nickname text,
  cover_photo_id uuid,
  location_id uuid,
  substrate text,
  pot_diameter_cm int,
  pot_type pot_type,
  self_watering boolean default false,
  acquired_date date,
  status plant_status default 'healthy',
  notes text,
  parent_plant_id uuid,
  archived boolean default false
);

-- events
create table if not exists events (
  id uuid default gen_random_uuid() primary key,
  plant_id uuid not null,
  user_id uuid not null,
  event_type event_type not null,
  event_date date default now(),
  notes text,
  batch_id uuid
);

-- photos
create table if not exists photos (
  id uuid default gen_random_uuid() primary key,
  plant_id uuid not null,
  user_id uuid not null,
  event_id uuid,
  storage_path text not null,
  taken_at timestamptz,
  is_cover_photo boolean default false
);

-- reminders
create table if not exists reminders (
  id uuid default gen_random_uuid() primary key,
  plant_id uuid not null,
  user_id uuid not null,
  remind_at timestamptz not null,
  note text,
  completed boolean default false
);

-- propagations
create table if not exists propagations (
  id uuid default gen_random_uuid() primary key,
  parent_plant_id uuid not null,
  resulting_plant_id uuid,
  user_id uuid not null,
  taken_date date,
  method text,
  given_away boolean default false,
  notes text
);

-- RLS placeholder: recommend enabling policies with auth.uid() = user_id on each table in migrations step

-- batch RPC
create or replace function create_events_batch(
  p_plant_ids uuid[], p_event_type event_type, p_notes text, p_event_date date
) returns setof events as $$
  insert into events (plant_id, user_id, event_type, notes, event_date, batch_id)
  select id, auth.uid(), p_event_type, p_notes, p_event_date, gen_random_uuid()
  from plants
  where id = any(p_plant_ids) and user_id = auth.uid()
  returning *;
$$ language sql security definer;

-- plant limit trigger
create or replace function check_plant_limit() returns trigger as $$
declare
  current_count int;
  user_tier subscription_tier;
begin
  select subscription_tier into user_tier from profiles where id = new.user_id;
  if user_tier = 'pro' then return new; end if;
  select count(*) into current_count from plants where user_id = new.user_id and archived = false;
  if current_count >= 25 then
    raise exception 'plant_limit_reached' using hint = 'Upgrade to Pro for unlimited plants';
  end if;
  return new;
end;
$$ language plpgsql security definer;

create trigger enforce_plant_limit before insert on plants
  for each row execute procedure check_plant_limit();

-- auto-profile trigger on signup
create function public.handle_new_user() returns trigger as $$
begin
  insert into public.profiles (id, subscription_tier) values (new.id, 'free');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created after insert on auth.users
  for each row execute procedure public.handle_new_user();
