# Setup Checklist

Use this checklist to ensure your repo-skeletor is fully configured.

## ☐ Prerequisites

- [ ] Git installed
- [ ] GitHub account created
- [ ] VS Code installed (recommended)
- [ ] Repository cloned locally

## ☐ API Keys Obtained

- [ ] Anthropic API key ([Get it here](https://console.anthropic.com/))
- [ ] Linear API key ([Get it here](https://linear.app/settings/api))
- [ ] Linear Team ID ([Find it here](https://linear.app/settings))
- [ ] Notion API key ([Get it here](https://www.notion.so/my-integrations))
- [ ] Notion Database ID ([Instructions](SECRETS.md#5-notion_spec_database_id))
- [ ] (Optional) Gemini API key ([Get it here](https://makersuite.google.com/))

## ☐ Local Setup

- [ ] Run `./setup.sh` successfully
- [ ] `.env` file created
- [ ] API keys added to `.env` file
- [ ] Verified all directories exist

## ☐ GitHub Configuration

- [ ] Repository settings accessed
- [ ] Navigated to Secrets and variables → Actions
- [ ] Added `ANTHROPIC_API_KEY` secret
- [ ] Added `LINEAR_API_KEY` secret
- [ ] Added `LINEAR_TEAM_ID` secret
- [ ] Added `NOTION_API_KEY` secret
- [ ] Added `NOTION_SPEC_DATABASE_ID` secret

## ☐ GitHub Actions

- [ ] Navigated to Settings → Actions → General
- [ ] Enabled "Allow all actions and reusable workflows"
- [ ] Saved settings
- [ ] Verified Actions tab is visible

## ☐ Notion Setup

- [ ] Created Notion database for specs
- [ ] Copied database ID
- [ ] Created Notion integration
- [ ] Connected integration to database
- [ ] Verified integration has permissions

## ☐ Linear Setup

- [ ] Created Linear workspace/team
- [ ] Generated API key
- [ ] Found team ID
- [ ] Tested API key works
- [ ] Configured team settings

## ☐ VS Code Extensions

- [ ] Opened VS Code
- [ ] Searched for "Continue" extension
- [ ] Installed Continue.dev extension
- [ ] Restarted VS Code
- [ ] Continue extension activated
- [ ] Verified `.continue/config.json` is recognized

## ☐ Testing

- [ ] Created test issue on GitHub
- [ ] Verified Linear sync workflow ran
- [ ] Checked Linear for synced issue
- [ ] Created test branch
- [ ] Made test commit
- [ ] Pushed test branch
- [ ] Created test PR
- [ ] Verified Notion sync workflow ran
- [ ] Checked Notion for documented PR

## ☐ Continue.dev Configuration

- [ ] Opened Continue in VS Code (Ctrl+L / Cmd+L)
- [ ] Verified Claude model is available
- [ ] Tested `/` command to see custom commands
- [ ] Tried `/linear` command
- [ ] Tried `/notion` command
- [ ] Tested code completion

## ☐ Verification

- [ ] All workflows show green checkmarks
- [ ] Linear issues are being created
- [ ] Notion pages are being created
- [ ] CI workflow runs on push
- [ ] Issue templates work
- [ ] PR template appears when creating PR

## ☐ Documentation Review

- [ ] Read [README.md](README.md)
- [ ] Read [QUICKSTART.md](QUICKSTART.md)
- [ ] Read [SECRETS.md](SECRETS.md)
- [ ] Read [.github/workflows/README.md](.github/workflows/README.md)
- [ ] Understand workflow triggers
- [ ] Know where to find logs

## ☐ Security

- [ ] `.env` file is gitignored
- [ ] No secrets in git history
- [ ] GitHub Secrets are set
- [ ] API keys are not in code
- [ ] API keys have minimum required permissions

## ☐ Customization (Optional)

- [ ] Updated README.md with project info
- [ ] Customized issue templates
- [ ] Customized PR template
- [ ] Modified workflow triggers if needed
- [ ] Adjusted AI model settings
- [ ] Added additional workflows

## ☐ Final Steps

- [ ] All items above checked
- [ ] Team members invited (if applicable)
- [ ] Repository visibility set (public/private)
- [ ] Branch protection rules configured (if needed)
- [ ] Ready to start developing!

## 🎉 Setup Complete!

Once all items are checked, you're ready to:
1. Create real issues and PRs
2. Use AI assistance with Continue.dev
3. Track work in Linear
4. Document in Notion
5. Enjoy automated workflows!

## Need Help?

If any step fails:
1. Check [SECRETS.md](SECRETS.md) for detailed instructions
2. Review [.github/workflows/README.md](.github/workflows/README.md) for workflow troubleshooting
3. View GitHub Actions logs in the Actions tab
4. Open an issue for support

## Maintenance Checklist

Regular maintenance tasks:

### Weekly
- [ ] Review GitHub Actions runs
- [ ] Check Linear sync status
- [ ] Verify Notion pages are updating

### Monthly
- [ ] Review API usage/limits
- [ ] Check for workflow updates
- [ ] Update dependencies if any

### Quarterly
- [ ] Rotate API keys
- [ ] Review and update documentation
- [ ] Check for new features in integrations

---

**Pro Tip**: Keep this checklist handy when setting up new projects with this template!
