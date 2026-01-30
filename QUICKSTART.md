# Quick Start Guide

Get up and running with repo-skeletor in 5 minutes!

## Prerequisites Checklist

- [ ] Git installed
- [ ] GitHub account
- [ ] VS Code (recommended)
- [ ] API keys ready (see below)

## Step-by-Step Setup

### 1. Clone or Use Template

```bash
# If using as template
# Click "Use this template" on GitHub

# Or clone
git clone https://github.com/clduab11/repo-skeletor.git
cd repo-skeletor
```

### 2. Get Your API Keys

**Required:**
- Anthropic (Claude): https://console.anthropic.com/
- Linear: https://linear.app/settings/api
- Notion: https://www.notion.so/my-integrations

**Optional:**
- Gemini: https://makersuite.google.com/

See [SECRETS.md](SECRETS.md) for detailed instructions.

### 3. Run Setup

```bash
chmod +x setup.sh
./setup.sh
```

### 4. Configure Local Environment

```bash
# Edit .env with your actual keys
nano .env
# or
code .env
```

### 5. Add GitHub Secrets

1. Go to: `Settings` → `Secrets and variables` → `Actions`
2. Click `New repository secret`
3. Add each secret:
   - `ANTHROPIC_API_KEY`
   - `LINEAR_API_KEY`
   - `NOTION_API_KEY`
   - `LINEAR_TEAM_ID`
   - `NOTION_SPEC_DATABASE_ID`

### 6. Enable GitHub Actions

1. Go to: `Settings` → `Actions` → `General`
2. Select: "Allow all actions and reusable workflows"
3. Click `Save`

### 7. Install Continue.dev

In VS Code:
1. Open Extensions (Ctrl+Shift+X)
2. Search "Continue"
3. Install "Continue - Codestral, Claude, and more"
4. Restart VS Code

### 8. Verify Setup

```bash
# Check workflows are valid
ls .github/workflows/

# Check configs exist
ls .claude/ .gemini/ .continue/

# Test a commit
git add .
git commit -m "Initial setup"
git push
```

## Quick Tips

### Using Continue.dev

- Press `Ctrl+L` (or `Cmd+L` on Mac) to open Continue
- Type `/` to see custom commands
- Use `/linear` to create Linear issues
- Use `/notion` to document in Notion

### GitHub Actions

- **CI**: Runs on every push to main/develop
- **Linear Sync**: Runs when issues/PRs are created/updated
- **Notion Sync**: Runs on pushes and PR events

### Common Commands

```bash
# View recent actions
gh run list

# View workflow logs
gh run view --log

# Create issue (syncs to Linear)
gh issue create

# Create PR (syncs to Linear & Notion)
gh pr create
```

## Troubleshooting

### "Secrets not found" in Actions

- Verify secrets are added in GitHub Settings
- Check names match exactly (case-sensitive)
- Wait a few minutes after adding secrets

### Continue.dev not working

- Check API key in `.continue/config.json`
- Verify VS Code extension is installed
- Restart VS Code

### Linear/Notion sync not working

- Check API keys are valid
- Verify IDs are correct (team ID, database ID)
- Check workflow run logs in Actions tab

## Next Steps

1. ✅ Create your first issue (will sync to Linear)
2. ✅ Make a code change
3. ✅ Create a PR (will sync to Linear & Notion)
4. ✅ Use Continue.dev for AI assistance
5. ✅ Customize workflows for your needs

## Resources

- [Full README](README.md)
- [Secrets Guide](SECRETS.md)
- [Contributing](CONTRIBUTING.md)
- [Continue.dev Docs](https://continue.dev/docs)
- [Linear API](https://developers.linear.app/)
- [Notion API](https://developers.notion.com/)

---

**Need help?** Open an issue or check the documentation.

Happy coding! 🚀
