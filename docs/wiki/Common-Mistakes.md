# Common Mistakes

> Learn from past mistakes to avoid repeating them

This document highlights common pitfalls when using the repo-skeletor template and how to avoid them.

## ❌ Mistake #1: Pushing to the Template Repository

### What Happened (REP-11)

The most critical mistake that can occur is **pushing project-specific changes back to the template repository**. This happened with the Beta-Trader project:

1. Developer cloned `repo-skeletor` repository
2. Renamed the directory locally to `beta-trader`
3. Filled in project-specific content (NautilusTrader trading platform documentation)
4. Committed and pushed changes
5. **Changes went to the template repository instead of a new project repository**

### Impact

- Template repository was corrupted with Beta-Trader specific content
- Root `README.md` and `AGENTS.md` contained project-specific documentation
- Template became unusable for creating new projects
- Required restoration from backup and significant cleanup

### How to Avoid

✅ **Correct Way: Use GitHub's "Use this template" feature**

```bash
# 1. On GitHub: Click "Use this template" → "Create a new repository"
#    Name it YOUR_PROJECT_NAME (not repo-skeletor)

# 2. Clone YOUR new repository
git clone https://github.com/YOUR_USERNAME/YOUR_PROJECT_NAME.git
cd YOUR_PROJECT_NAME

# 3. Verify you're in the right repository
git remote -v
# Should show: YOUR_USERNAME/YOUR_PROJECT_NAME
# Should NOT show: clduab11/repo-skeletor
```

❌ **Wrong Way: Clone and rename without changing remote**

```bash
# DON'T DO THIS:
git clone https://github.com/clduab11/repo-skeletor.git
cd repo-skeletor
# Rename locally but keep same git remote
# Make changes
git push  # ❌ This pushes to the template!
```

### Pre-Commit Checklist

Before making your first commit to a new project:

- [ ] I used "Use this template" to create a NEW repository
- [ ] I cloned MY new repository (not repo-skeletor)
- [ ] I verified `git remote -v` shows MY repository
- [ ] I ran `./setup.sh` to configure the template
- [ ] I'm certain I'm NOT pushing to clduab11/repo-skeletor

### Emergency Recovery

If you accidentally pushed to the template:

1. **Don't panic** - The changes can be reverted
2. **Stop immediately** - Don't make more commits
3. **Contact repository maintainer** - They can help restore the template
4. **Create your actual project repository** - Use the correct process
5. **Cherry-pick your changes** - Move them to the correct repository

---

## ❌ Mistake #2: Not Running setup.sh

### What Happens

Forgetting to run `setup.sh` means:
- Placeholders like `{{PROJECT_NAME}}` remain in configuration files
- AI assistants (Claude Code, Codex CLI, Copilot) are misconfigured
- GitHub Actions workflows may fail
- Documentation references wrong project name

### How to Avoid

✅ **Always run setup.sh immediately after cloning:**

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_PROJECT.git
cd YOUR_PROJECT
./setup.sh  # Run this right away!
```

The script will:
- Prompt for project details
- Replace all placeholders in config files
- Create `.env.example`
- Update `.gitignore`
- Initialize git (if needed)

---

## ❌ Mistake #3: Committing Secrets

### What Happens

Accidentally committing API keys, tokens, or credentials:
- Exposes secrets publicly (if repo is public)
- Creates security vulnerabilities
- Requires secret rotation and cleanup
- Can trigger security alerts

### How to Avoid

✅ **Use environment variables:**

```bash
# 1. Copy the example file
cp .env.example .env

# 2. Fill in your secrets in .env (NOT committed)
ANTHROPIC_API_KEY=sk-ant-...
LINEAR_API_KEY=lin_api_...

# 3. Verify .env is in .gitignore
cat .gitignore | grep ".env"
```

✅ **Add GitHub repository secrets:**

Go to: Settings → Secrets and variables → Actions → New repository secret

Never hardcode secrets in files:

```typescript
// ❌ DON'T DO THIS:
const API_KEY = 'sk-ant-1234567890abcdef';

// ✅ DO THIS:
const API_KEY = process.env.ANTHROPIC_API_KEY;
if (!API_KEY) {
  throw new Error('ANTHROPIC_API_KEY environment variable is required');
}
```

---

## ❌ Mistake #4: Modifying Template Files Instead of Project Files

### What Happens

Editing files in the `template/` directory when you meant to edit root files:
- Changes don't apply to your project
- Confusion about which files are active
- Template backup files get modified

### How to Avoid

✅ **Understand the directory structure:**

```
your-project/
├── .claude/settings.json      ← Edit this (Claude Code config)
├── .claude/commands/          ← Edit these (slash commands)
├── .claude/agents/            ← Edit these (subagents)
├── .codex/config.toml         ← Edit this (Codex CLI config)
├── .mcp.json                  ← Edit this (shared MCP catalog)
├── AGENTS.md                  ← Edit this (cross-agent source of truth)
├── CLAUDE.md                  ← Edit this (Claude-specific nuance)
├── README.md                  ← Edit this
├── setup.sh                   ← Run this once
└── docs/wiki/                 ← Edit these (project docs)
```

The `template/` directory is a **backup reference**. After running `setup.sh`, you should edit the files in the root and subdirectories, not in `template/`.

---

## ❌ Mistake #5: Skipping Git Remote Verification

### What Happens

Not verifying your git remote URL leads to:
- Pushing to wrong repository
- Confusion about where code is stored
- Potential data loss or overwrite

### How to Avoid

✅ **Always verify your remote:**

```bash
# After cloning, immediately check:
git remote -v

# Should output something like:
# origin  https://github.com/YOUR_USERNAME/YOUR_PROJECT.git (fetch)
# origin  https://github.com/YOUR_USERNAME/YOUR_PROJECT.git (push)

# Should NOT output:
# origin  https://github.com/clduab11/repo-skeletor.git (fetch)
# origin  https://github.com/clduab11/repo-skeletor.git (push)
```

✅ **Change remote if needed:**

```bash
git remote set-url origin https://github.com/YOUR_USERNAME/YOUR_PROJECT.git
git remote -v  # Verify the change
```

---

## ❌ Mistake #6: Not Understanding Template vs. Project

### What Happens

Confusion about the difference between the template and your project:
- Trying to use repo-skeletor directly as your project
- Not understanding the setup process
- Missing the point of templates

### Understanding the Distinction

**Template Repository (repo-skeletor):**
- Is a **blueprint** for new projects
- Contains **placeholders** like `{{PROJECT_NAME}}`
- Should **never** contain project-specific code
- Is **shared** across all projects created from it

**Your Project Repository:**
- Is a **specific implementation**
- Has **real values** instead of placeholders
- Contains **your project's code** and configuration
- Is **independent** from the template

**Analogy:**
- Template = Cookie cutter 🍪
- Your project = The cookie you make with it

You don't modify the cookie cutter every time you make a cookie. You use it to create new cookies!

---

## ❌ Mistake #7: Ignoring GitHub Actions Failures

### What Happens

Not paying attention to workflow failures means:
- Template protection checks are ignored
- Project-specific content slips through
- CI/CD pipelines are broken
- Quality issues accumulate

### How to Avoid

✅ **Monitor the Template Protection workflow:**

After pushing to main, check:
- Actions tab on GitHub
- Email notifications for failures
- PR status checks

✅ **Address failures immediately:**

If `template-protection.yml` fails:
1. Read the error message carefully
2. Check which files have issues
3. Remove project-specific content
4. Verify placeholders are present
5. Push fixes

---

## 🎯 Best Practices Summary

### Before Starting
- [ ] Use "Use this template" on GitHub
- [ ] Clone YOUR new repository
- [ ] Verify git remote URL
- [ ] Run `./setup.sh`

### During Development
- [ ] Use `.env` for secrets
- [ ] Never commit sensitive data
- [ ] Edit files in root, not `template/`
- [ ] Follow conventional commits

### Before Pushing
- [ ] Double-check `git remote -v`
- [ ] Ensure you're NOT pushing to repo-skeletor
- [ ] Review files being committed
- [ ] Check for secrets in staged files

### After Pushing
- [ ] Monitor GitHub Actions
- [ ] Address any workflow failures
- [ ] Review deployment status

---

## 🆘 Getting Help

If you:
- Think you pushed to the wrong repository
- Can't figure out why workflows are failing
- Need help understanding the template
- Want to contribute improvements

**Create an issue on the template repository:**
- For template issues: [clduab11/repo-skeletor/issues](https://github.com/clduab11/repo-skeletor/issues)
- For project issues: Create issue in YOUR project repository

---

## 📚 Related Documentation

- [Proper Template Usage](./Proper-Template-Usage.md) - Correct way to use the template
- [Quick Start Guide](./Quick-Start-Guide.md) - Getting started quickly
- [Template Structure](./Template-Structure.md) - Understanding the repository layout
- [Customization Guide](./Customization-Guide.md) - Adapting to your needs

---

**Remember:** The template is a tool to help you start projects faster. Take a few minutes to understand it properly, and you'll save hours of configuration time!
