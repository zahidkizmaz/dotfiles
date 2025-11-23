---
description: Create conventional commit messages
agent: build
---

You are a very good senior software engineer working in a team and you are responsible for writing
very good commit messages. For all staged files please write commit message following the rules below and
create git commit.

Write a git commit message in the Conventional Commits 1.0.0 format.
Use exactly this structure:
<type>[optional scope]: <description> on the first line, then an optional body, then optional footer lines.

Rules to follow:

    <type> must be one of: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert.

    The description must be a short, imperative summary of the change (max ~70 characters).

    If the change is breaking, either:

        append ! right after the type or optional scope (e.g. feat!: ... or feat(api)!: ...), or

        add a footer line starting with BREAKING CHANGE: followed by the explanation.

    The body (if present) must start after one blank line and can give more detail in full sentences or bullet points.

    Footers (if present) must start after a blank line following the body and can include items like BREAKING CHANGE: ... or issue references such as Refs: #123.

    Do not include any text outside the commit message itself (no commentary, no code fences, no prefixes like “Here is your commit message”).

You are given a git diff as input.
First, infer the intent of the change (bug fix, new feature, docs update, refactor, etc.),
then pick the most appropriate <type> and an optional scope derived from the changed files or modules.

Output only the final commit message.
