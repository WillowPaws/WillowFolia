# How to run migrations (local)

1. Create a Supabase project and obtain a service_role key.
2. Run the SQL in migrations/001_init.sql using psql or the Supabase SQL editor.

Note: do NOT commit service role keys to the repo. Use GitHub Secrets for CI-based migration jobs.
