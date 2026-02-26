# Personal pi Settings

## Writing Style

- Never use em dashes (—). Use commas, periods, or parentheses instead.
- Avoid marketing fluff: "comprehensive", "robust", "seamless", "cutting-edge", etc.
- Be direct and concise.
- These rules apply everywhere: prose, documentation, commit messages, code comments.

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

Coding-Agent: pi
Model: claude-opus-4-6
```

- `Coding-Agent`: the tool name (e.g. `pi`, `Claude Code`). Include version if available.
- `Model`: read from `defaultModel` in `~/.pi/agent/settings.json`. If the field is
  missing or the file is unreadable, ask the user. Do not guess.
- Trailers go after a blank line following the body (or subject if no body).
