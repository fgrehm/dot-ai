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

### General Commit Message Preferences

- Prefer present tense: "add feature" not "added feature"
- Keep first line under 72 characters when possible
- Use body text for complex changes requiring explanation
- Reference issues/PRs when relevant: `fixes #123`

### AI Attribution Trailers

Always add git trailers to identify AI-assisted commits:

```
feat(auth): add OAuth login support

Optional body text.

Coding-Agent: Claude Code
Model: claude-sonnet-4-20250514
```

- `Coding-Agent`: the tool name (e.g. `Claude Code`, `pi`). Include version if available.
- `Model`: the most specific model identifier available (e.g. `claude-sonnet-4-20250514`).
- Trailers go after a blank line following the body (or subject if no body).
