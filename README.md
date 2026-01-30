# repo-skeletor

> Exoskeleton for all future templates, complete with extra tools and functionalities.

A comprehensive solo dev workflow template that integrates Claude Code, Gemini, Continue.dev, Linear, and Notion with bi-directional sync capabilities.

## 🚀 Features

- **AI-Powered Development**: Integration with Claude (Anthropic) and Gemini AI assistants
- **Continue.dev**: Advanced code completion and AI-assisted development in VS Code
- **Linear Integration**: Bi-directional sync between GitHub issues/PRs and Linear issues
- **Notion Integration**: Automatic documentation and sync with Notion databases
- **GitHub Actions**: Automated workflows for CI/CD and integrations
- **Quick Setup**: One-command setup script to get started

## 📋 Prerequisites

- Git
- Node.js (optional, for projects that use it)
- VS Code (recommended for Continue.dev)
- GitHub account
- Accounts for:
  - [Anthropic](https://console.anthropic.com/) (for Claude API)
  - [Linear](https://linear.app/) (for issue tracking)
  - [Notion](https://www.notion.so/) (for documentation)
  - [Google AI Studio](https://makersuite.google.com/) (optional, for Gemini)

## 🔧 Quick Start

1. **Clone this repository:**
   ```bash
   git clone https://github.com/clduab11/repo-skeletor.git
   cd repo-skeletor
   ```

2. **Run the setup script:**
   ```bash
   ./setup.sh
   ```

3. **Configure your API keys:**
   - Edit `.env` file with your actual API keys
   - Add secrets to GitHub repository settings

4. **Enable GitHub Actions:**
   - Go to repository Settings > Actions > General
   - Enable "Allow all actions and reusable workflows"

## 🔑 Required Secrets

Add these secrets to your GitHub repository (Settings > Secrets and variables > Actions):

| Secret Name | Description | Where to Get It |
|-------------|-------------|-----------------|
| `ANTHROPIC_API_KEY` | Anthropic API key for Claude | [Anthropic Console](https://console.anthropic.com/) |
| `LINEAR_API_KEY` | Linear API key | [Linear Settings > API](https://linear.app/settings/api) |
| `NOTION_API_KEY` | Notion integration token | [Notion Integrations](https://www.notion.so/my-integrations) |
| `LINEAR_TEAM_ID` | Your Linear team ID | Found in Linear URL or API |
| `NOTION_SPEC_DATABASE_ID` | Notion database ID for specs | From your Notion database URL |

### Getting Notion Database ID

1. Open your Notion database
2. Click "..." menu > "Copy link"
3. The ID is the long string in the URL: `https://notion.so/workspace/<DATABASE_ID>?v=...`

### Getting Linear Team ID

1. Go to your Linear workspace
2. Open Settings > API
3. Create a personal API key
4. Use the Linear API or URL to find your team ID

## 📁 Directory Structure

```
repo-skeletor/
├── .claude/                 # Claude AI configuration
│   └── project-config.json
├── .gemini/                 # Gemini AI configuration
│   └── config.json
├── .continue/               # Continue.dev configuration
│   └── config.json
├── .github/
│   └── workflows/           # GitHub Actions workflows
│       ├── ci.yml          # Continuous Integration
│       ├── linear-sync.yml # Linear bi-directional sync
│       └── notion-sync.yml # Notion bi-directional sync
├── setup.sh                 # Setup script
├── .env.example            # Environment variables template
└── README.md               # This file
```

## 🔄 Integrations

### Claude Code

Configuration in `.claude/project-config.json`. Uses Claude 3.5 Sonnet for code assistance.

### Gemini

Configuration in `.gemini/config.json`. Alternative AI assistant for code completion and review.

### Continue.dev

Install the [Continue extension](https://marketplace.visualstudio.com/items?itemName=Continue.continue) for VS Code. Configuration in `.continue/config.json` includes:
- Multiple AI models (Claude, Gemini)
- Custom commands for Linear and Notion sync
- Code completion and context providers

### Linear Sync

Automatically syncs GitHub issues and PRs to Linear:
- Creates Linear issues when GitHub issues are created
- Updates Linear issues when GitHub issues are updated
- Links PRs to Linear issues

### Notion Sync

Automatically documents changes in Notion:
- Creates Notion pages for PRs and issues
- Syncs commit information
- Maintains a knowledge base

## 🛠️ Usage

### Basic Development Workflow

1. **Create an issue in GitHub** → Automatically synced to Linear
2. **Create a branch** for your feature/fix
3. **Use Continue.dev** in VS Code for AI-assisted coding
4. **Commit changes** → Automatically documented in Notion
5. **Create PR** → Synced to Linear and Notion
6. **CI runs** automatically on push

### Custom Continue.dev Commands

In VS Code with Continue.dev:
- `/linear` - Create or update Linear issue
- `/notion` - Document code in Notion
- `/test` - Generate test suite
- `/commit` - Generate commit message

## 📝 Customization

### Adding New Workflows

Add new GitHub Actions workflows in `.github/workflows/`. See existing workflows for examples.

### Modifying AI Configurations

Edit configuration files in `.claude/`, `.gemini/`, or `.continue/` directories to customize AI behavior.

### Environment Variables

Create a `.env` file (gitignored) for local development:
```bash
cp .env.example .env
# Edit .env with your keys
```

## 🔒 Security

- **Never commit** `.env` file or API keys
- Use GitHub Secrets for CI/CD
- Rotate API keys regularly
- Review workflow permissions

## 🤝 Contributing

This is a template repository. Fork it and customize for your needs!

## 📄 License

See [LICENSE](LICENSE) file.

## 🆘 Support

For issues with:
- **Claude**: [Anthropic Documentation](https://docs.anthropic.com/)
- **Linear**: [Linear API Docs](https://developers.linear.app/)
- **Notion**: [Notion API Docs](https://developers.notion.com/)
- **Continue.dev**: [Continue Documentation](https://continue.dev/docs)

## 🎯 Roadmap

- [ ] Add support for more AI models
- [ ] Implement webhook listeners for reverse sync
- [ ] Add Slack notifications
- [ ] Create project templates for common frameworks
- [ ] Add automated testing workflows

---

Built with ❤️ for solo developers who want powerful integrations without the overhead.
