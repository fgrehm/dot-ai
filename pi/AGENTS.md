# Personal pi Settings

## Writing Style

- Never use em dashes (—). Use commas, periods, or parentheses instead.
- Use ASCII quotation marks (`"` and `'`) in code and comments, not Unicode typographic quotes (`"` U+201D, `"` U+201C, etc.). Linters like gofmt and golangci-lint will restore Unicode characters from the AST, causing staged changes to revert at commit time.
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

### AI Attribution

Add an `AI-Agent` trailer to every commit:

```
feat(auth): add OAuth login support

Optional body text.

AI-Agent: pi (claude-opus-4-6)
```

Format: `AI-Agent: <tool> (<model>)`. Use only values you know for certain.
If you do not know the model, omit the parenthetical rather than guessing.
Trailers go after a blank line following the body (or subject if no body).
