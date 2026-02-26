# Personal Claude Code Settings

## Writing Style

- Never use em dashes (—). Use commas, periods, or parentheses instead.
- Avoid marketing fluff: "comprehensive", "robust", "seamless", "cutting-edge", etc.
- Be direct and concise.

## Git Commit Guidelines

### Conventional Commits with Scopes

Use scopes when they clarify what component/area changed:

- `feat(auth): add OAuth login support`
- `fix(docker): resolve container networking issue`
- `chore(deps): update React to v18`

Skip scopes for broad/obvious changes:

- `feat: implement user dashboard`
- `fix: resolve memory leak in background tasks`

### General Preferences

- Prefer present tense: "add feature" not "added feature"
- Keep first line under 72 characters when possible
- Use body text for complex changes requiring explanation
- Reference issues/PRs when relevant: `fixes #123`
