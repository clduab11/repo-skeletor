# Template Structure

Understanding the repository organization and key files in repo-skeletor.

## 📁 Directory Structure

```
repo-skeletor/
├── .claude/
│   ├── settings.json           # Claude Code permissions + hooks
│   ├── commands/               # Project slash commands (/review, /spec, ...)
│   └── agents/                 # Subagent definitions (code-reviewer, etc.)
├── .codex/
│   └── config.toml             # Codex CLI config (model, profiles, MCP mirror)
├── .github/
│   ├── branch-protection.json  # Declarative branch protection for main
│   ├── copilot-instructions.md # GitHub Copilot guidance
│   ├── labels.yml              # Canonical label taxonomy
│   └── workflows/              # GitHub Actions (CI, claude.yml, deploy, sync, template-protection)
├── docs/
│   ├── coding-style.md         # Project-wide coding standards (agent source of truth)
│   └── wiki/                   # This documentation
├── scripts/
│   ├── install-hooks.sh        # Installs pre-commit hooks via the pre-commit framework
│   ├── apply-branch-protection.sh  # Applies .github/branch-protection.json via gh CLI
│   └── check-placeholders.sh   # Guards staged commits against stray {{PLACEHOLDERS}}
├── .mcp.json                   # Shared MCP server catalog (Claude Code + Codex)
├── .pre-commit-config.yaml     # Pre-commit framework config (gitleaks, conventional-commits, ...)
├── .markdownlint.yaml          # Markdown lint rules
├── AGENTS.md                   # Cross-agent source of truth (rules every agent reads first)
├── CLAUDE.md                   # Claude-specific nuance (complements AGENTS.md)
├── FORK_AND_CUSTOMIZE.md       # Step-by-step customization checklist
├── setup.sh                    # Interactive bootstrap script
├── LICENSE
└── README.md
```

## 🔧 Configuration Files

### AI Assistant Configurations

#### `settings.json` - Claude Code Settings
Configures Claude Code behavior, permissions, and integrations:
```json
{
  "project": {
    "name": "{{PROJECT_NAME}}",
    "type": "{{PROJECT_TYPE}}"
  },
  "permissions": {
    "allowedTools": ["Edit", "Read", "Write", "Bash", "Glob", "Grep"],
    "allowedDirectories": ["src/", "lib/", "tests/", "docs/"]
  }
}
```

**Key settings:**
- **allowedTools**: Controls which operations Claude can perform
- **allowedDirectories**: Restricts file access for security
- **integrations**: Linear and Notion integration settings

#### `.codex/config.toml` - Codex CLI Configuration
TOML config for OpenAI Codex CLI. Controls model, approval policy, sandbox mode, and mirrors the MCP server catalog:
```toml
model = "gpt-5-codex"
approval_policy = "on-request"
sandbox_mode = "workspace-write"

[profiles.review]
approval_policy = "never"
sandbox_mode = "read-only"

[mcp_servers.linear]
transport = "http"
url = "https://mcp.linear.app/sse"
```

**Key sections:**
- **model / approval_policy / sandbox_mode**: Default agent posture
- **profiles.***: Named profiles (`review`, `ship`, etc.) for different postures
- **mcp_servers.***: Mirror of `.mcp.json` so Codex and Claude share a catalog
- **shell_environment_policy**: Excludes `*_TOKEN`, `*_SECRET`, `*_KEY`, `*_PASSWORD` from shell inheritance

#### `.mcp.json` - Shared MCP Server Catalog
Canonical MCP catalog consumed natively by Claude Code (and mirrored into `.codex/config.toml`):
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}" }
    },
    "linear": {
      "type": "http",
      "url": "https://mcp.linear.app/sse"
    }
  }
}
```

**Available servers (default catalog):**
- **filesystem**: Safe file operations scoped to the repo
- **github**: Repository, PR, and issue management
- **git**: Local git state + log
- **memory**: Persistent context across sessions
- **sequential-thinking**: Step-by-step reasoning helper
- **linear**: Issue tracking (HTTP + OAuth)
- **notion**: Documentation access (HTTP + OAuth)
- **context7**: Up-to-date library documentation (HTTP)

#### `docs/coding-style.md` - Coding Standards
Project-wide coding conventions. Referenced by `AGENTS.md`, `CLAUDE.md`, and `.github/copilot-instructions.md` as the single source of truth. The Claude review workflow also cites it during auto-reviews.

#### `AGENTS.md` - Cross-Agent Source of Truth
The file every agent reads first. Contains hard rules, the MCP catalog table, placeholder taxonomy, and conflict-resolution decision tree. Edit this file when a rule should apply to every agent; edit `CLAUDE.md` only for Claude-specific nuance.

### Workflow Files

#### `ci.yml` - Continuous Integration
**Purpose**: Automated testing, linting, and building on every PR and push.

**Jobs:**
- `lint`: ESLint, TypeScript type checking, Prettier
- `test`: Unit tests with coverage
- `build`: Production build verification
- `integration`: Integration tests (main branch only)
- `security`: Security audit with pnpm and Snyk

**Triggers:**
```yaml
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]
```

#### `claude.yml` - Claude Code Automation
**Purpose**: AI-powered code assistance via @claude mentions.

**Features:**
- Responds to `@claude` mentions in issues and PRs
- Automated PR reviews
- Creates branches following Linear patterns
- Sticky comments for ongoing assistance

**Triggers:**
```yaml
on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
  issues:
    types: [assigned, labeled]
```

#### `deploy.yml` - Deployment Pipeline
**Purpose**: Automated deployments to staging and production.

**Environments:**
- **Staging**: Auto-deploys from `main` branch
- **Production**: Deploys from tags like `v1.0.0`

**Jobs:**
- `setup`: Determine environment and version
- `build`: Create production build
- `deploy-staging`: Deploy to staging environment
- `deploy-production`: Deploy to production with release creation

#### `linear-to-notion-sync.yml` - Linear → Notion Sync
**Purpose**: Sync Linear issues to Notion database.

**Triggers:**
- Repository dispatch (Linear webhook)
- Manual workflow dispatch

**Process:**
1. Fetch Linear issue data via API
2. Map Linear fields to Notion properties
3. Create or update Notion page
4. Link back to Linear

#### `notion-spec-to-linear.yml` - Notion → Linear Conversion
**Purpose**: Convert Notion spec documents into Linear epics with sub-issues.

**Process:**
1. Parse Notion page content
2. Extract tasks from checkboxes and lists
3. Create Linear epic issue
4. Create sub-issues for each task
5. Update Notion page with Linear links

### Template Files

#### `golden-repo-template/README.md`
Template README that gets customized during setup. Contains:
- Project overview structure
- Setup instructions
- Workflow documentation
- Branch naming conventions
- Security guidelines

#### `setup.sh`
Interactive shell script that:
1. Prompts for project details
2. Replaces `{{PLACEHOLDERS}}` in all config files
3. Creates `.env.example`
4. Updates `.gitignore`
5. Initializes git repository

## 📦 When Using the Template

After running `setup.sh`, your new project will have:

```
your-project/
├── .claude/
│   ├── settings.json           # ← Claude Code permissions (customized)
│   ├── commands/               # ← Project slash commands
│   └── agents/                 # ← Subagent definitions
├── .codex/
│   └── config.toml             # ← Codex CLI config (mirrors MCP catalog)
├── .github/
│   ├── branch-protection.json  # ← Applied via scripts/apply-branch-protection.sh
│   ├── copilot-instructions.md # ← Copilot guidance
│   ├── labels.yml              # ← Label taxonomy
│   └── workflows/
│       ├── claude.yml          # ← @claude + auto-review
│       ├── ci.yml              # ← CI pipeline
│       ├── deploy.yml          # ← Deployment
│       ├── template-protection.yml
│       ├── linear-to-notion-sync.yml
│       └── notion-spec-to-linear.yml
├── docs/
│   ├── coding-style.md         # ← Coding standards (agent source of truth)
│   └── wiki/                   # ← This documentation
├── scripts/
│   ├── install-hooks.sh
│   ├── apply-branch-protection.sh
│   └── check-placeholders.sh
├── .mcp.json                   # ← Shared MCP catalog (Claude + Codex)
├── .pre-commit-config.yaml
├── .markdownlint.yaml
├── AGENTS.md                   # ← Cross-agent rules (read first)
├── CLAUDE.md                   # ← Claude-specific nuance
├── src/                        # ← Your source code
├── tests/                      # ← Your tests
├── .env                        # ← Your secrets (gitignored)
├── .env.example               # ← Template for secrets
├── .gitignore                 # ← Updated with template patterns
├── package.json               # ← Your project dependencies
└── README.md                  # ← Customized README
```

## 🔑 Key Concepts

### Placeholders
Template files use placeholders that get replaced by `setup.sh`:

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `{{PROJECT_NAME}}` | Project name | `my-awesome-api` |
| `{{PROJECT_DESCRIPTION}}` | Brief description | `REST API for user management` |
| `{{PROJECT_TYPE}}` | Project type | `api`, `web`, `cli`, `lib` |
| `{{PROJECT_DOMAIN}}` | Domain name | `example.com` |
| `{{NOTION_SPEC_DATABASE_ID}}` | Notion database ID | `abc123...` |
| `{{NOTION_WIKI_PAGE_ID}}` | Notion wiki page ID | `def456...` |
| `{{LINEAR_TEAM_ID}}` | Linear team ID | `a1b2c3d4...` |

### File Patterns to Ignore

The template includes comprehensive `.gitignore` patterns:

```gitignore
# Never commit
.env
.env.local
.env.*.local
*.key
*.pem
secrets/

# Build artifacts
dist/
build/
.next/
coverage/

# Dependencies
node_modules/
.pnpm-store/
```

## 📝 Customizing the Structure

### Adding New Workflows
1. Create `.github/workflows/` directory
2. Add workflow files (`.yml`)
3. Reference secrets in `env:` sections
4. Test with `workflow_dispatch` trigger first

### Adding New MCP Servers
1. Edit `mcp-servers.yaml`
2. Add server configuration:
   ```yaml
   - name: "my-server"
     command: "npx"
     args: ["-y", "@org/mcp-server-name"]
     env:
       API_KEY: "${MY_API_KEY}"
   ```
3. Add required secrets to `.env`

### Modifying Claude Settings
1. Edit `settings.json`
2. Adjust `allowedTools` for more/less permissions
3. Update `allowedDirectories` for file access
4. Configure integrations as needed

---

**Previous:** [Quick Start Guide](./Quick-Start-Guide.md) | **Next:** [GitHub Actions Architecture](./GitHub-Actions-Architecture.md) →
