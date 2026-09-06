# Branch protection and CI

This commit adds two GitHub Actions workflows used as required status checks for branch protection.

Required checks (workflow names):
- Lint
- Test

Next steps:
1. In the repository settings, enable branch protection for the main branch and require the above status checks before merging.
2. Once branch protection is enabled, reply in the chat and I will push the full MVP to main.
