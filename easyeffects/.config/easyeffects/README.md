# EasyEffects Config (Framework 13 Laptop)

Presets sourced from: https://github.com/ceiphr/ee-framework-presets
IR file from Framework official docs: https://github.com/FrameworkComputer/linux-docs/tree/main/easy-effects

## Layout (EasyEffects 8.0+)

```
~/.config/easyeffects/db/        ← runtime database files (gitignored)
~/.local/share/easyeffects/output/ ← preset JSON files (tracked)
```

The preset files live under `.local/share/` because EasyEffects 8.0+
migrated presets/autoload/IRs from `~/.config/easyeffects/` to
`~/.local/share/easyeffects/`. The `db/` directory stays in
`~/.config/easyeffects/` but is gitignored since it's runtime state.

Stow handles both paths with a single command thanks to the
`~/.local/share/` tree under this stow package.
