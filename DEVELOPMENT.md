# Development notes

- CI workflows: .github/workflows/lint.yml and test.yml are present. Branch protection requires these checks.
- To run with Supabase, set SUPABASE_URL and SUPABASE_ANON_KEY in your environment and switch EXPO_PUBLIC_USE_MOCK to false.
- RevenueCat / Sentry / PostHog are placeholders — integrate their SDKs and set secrets when ready.

TODOs:
- Implement full Expo Router file structure and screens.
- Replace AppRouter placeholder with actual navigation and screens.
- Add UI components and style system.
- Add automated migrations job (create a minimal-action that uses SUPABASE_SERVICE_ROLE_KEY in a protected environment).
