# Contributing to ADotFiles

Thanks for your interest! This is a personal dotfiles framework, but contributions that improve the **modular design** or **cross-device sync mechanism** are welcome.

## How to Contribute

1. **Fork** the repository
2. Create a feature branch: `git checkout -b feature/your-idea`
3. Make your changes
4. Test on a clean macOS environment (or at minimum with `adot doctor`)
5. Commit with a descriptive message following [Conventional Commits](https://www.conventionalcommits.org/)
6. Open a **Pull Request**

## Commit Style

```
type: short description

- feat: new feature
- fix: bug fix
- docs: documentation
- chore: maintenance
```

## Scope

### In scope
- Bug fixes in `setup.sh` or zsh modules
- Improvements to the modular loading mechanism
- Better cross-device compatibility (macOS)
- Documentation improvements

### Out of scope
- Adding Linux/WSL support (macOS-only by design)
- Adding Bash/Fish support (Zsh-only by design)
- Personal preference changes (aliases, themes, etc.)

## Testing

Before submitting, verify:

```bash
bash setup.sh doctor        # All checks pass
bash setup.sh install --dry-run  # No errors in dry run
source ~/.zshrc              # Shell loads without errors
```

## Questions?

Open an [issue](https://github.com/ArnoFrost/ADotFiles/issues) for discussion.
