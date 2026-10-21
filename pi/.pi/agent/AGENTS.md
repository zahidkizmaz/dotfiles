# Global instructions

User-level context file — applies to every project and machine. Keep project-specific rules in that repo's own `AGENTS.md`. Add a rule here only after the same mistake has happened twice.

## Working agreements

- Be concise: no preamble, no restating the task, no narrating obvious steps.
- Fix root causes; don't leave one-off workarounds or settings behind.
- Read the relevant files/docs first — don't guess APIs, options, or attribute names.
- Validate before applying (build / eval / dry-run).
- Prefer declarative, config-as-code changes. Machines are Nix-managed (NixOS / nix-darwin); prefer the dotfiles flake over imperative edits.

## Context hygiene

- Never dump large output or whole files into context. Aggregate first with `rg`/`jq`/`awk`/`sort`/`uniq`/`wc`/`head`, or a short script that prints only the result.
- For questions spanning many files, compute the answer in code and print just the summary.
- Don't re-read a file already in the conversation; search it or refer back.
- For long fetched pages, pull only the relevant slice (stored content) instead of copying the whole page.

## Boundaries

- Never commit secrets.
- Ask before adding dependencies.
- Ask before destructive or irreversible actions (force-push, `rm -rf`, history rewrites, dropping data).
