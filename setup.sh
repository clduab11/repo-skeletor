#!/bin/bash
# Repo Template Setup Script
# Praxen Development

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════╗"
echo "║     repo-skeletor — project bootstrap             ║"
echo "║     Praxen Development                            ║"
echo "╚═══════════════════════════════════════════════════╝"
echo -e "${NC}"

# Safety Check 1: Verify this is a new project, not the template
CURRENT_DIR=$(basename "$PWD")
if [[ "$CURRENT_DIR" == "repo-skeletor" ]]; then
    echo -e "${RED}"
    echo "╔═══════════════════════════════════════════════════╗"
    echo "║  ⚠️  WARNING: You appear to be in the            ║"
    echo "║      template repository!                         ║"
    echo "╚═══════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo -e "${YELLOW}This setup script is for NEW projects created from the template.${NC}"
    echo -e "${YELLOW}It should NOT be run in the template repository itself.${NC}"
    echo ""
    echo "Did you:"
    echo "1. Clone repo-skeletor directly?"
    echo "2. Forget to rename the directory?"
    echo ""
    echo -e "${GREEN}Correct process:${NC}"
    echo "1. Use 'Use this template' on GitHub to create YOUR repository"
    echo "2. Clone YOUR repository (not repo-skeletor)"
    echo "3. Run this setup script"
    echo ""
    read -p "Are you SURE you want to continue? (type 'yes' to proceed): " CONFIRM
    if [[ "$CONFIRM" != "yes" ]]; then
        echo -e "${RED}Setup cancelled. Please follow the proper template usage guide.${NC}"
        echo "📖 See: docs/wiki/Proper-Template-Usage.md"
        exit 1
    fi
fi

# Safety Check 2: Verify git remote
if [[ -d ".git" ]]; then
    REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
    if [[ "$REMOTE_URL" == *"clduab11/repo-skeletor"* ]]; then
        echo -e "${RED}"
        echo "╔═══════════════════════════════════════════════════╗"
        echo "║  🚨 CRITICAL: Git remote points to template!     ║"
        echo "╚═══════════════════════════════════════════════════╝"
        echo -e "${NC}"
        echo ""
        echo -e "${RED}Your git remote is still pointing to the template repository!${NC}"
        echo "Current remote: $REMOTE_URL"
        echo ""
        echo "If you push changes, they will go to the TEMPLATE, not your project!"
        echo ""
        echo -e "${YELLOW}You must change the remote URL before continuing.${NC}"
        echo ""
        read -p "Enter your NEW repository URL (e.g., https://github.com/you/your-project.git): " NEW_REMOTE
        if [[ -n "$NEW_REMOTE" ]]; then
            git remote set-url origin "$NEW_REMOTE"
            echo -e "${GREEN}✓ Remote URL updated to: $NEW_REMOTE${NC}"
        else
            echo -e "${RED}Setup cancelled. Please set up your repository correctly.${NC}"
            echo "📖 See: docs/wiki/Proper-Template-Usage.md"
            exit 1
        fi
    fi
fi

# Confirmation prompt
echo -e "${YELLOW}Are you setting up a NEW project from this template?${NC}"
echo "This will replace all placeholders with your project details."
echo ""
read -p "Continue with setup? (yes/no): " SETUP_CONFIRM
if [[ "$SETUP_CONFIRM" != "yes" ]]; then
    echo -e "${YELLOW}Setup cancelled.${NC}"
    exit 0
fi

echo ""
read -p "Project Name: " PROJECT_NAME
read -p "Project Description: " PROJECT_DESCRIPTION
read -p "Project Type (api/web/cli/lib): " PROJECT_TYPE
read -p "Project Domain (e.g., example.com): " PROJECT_DOMAIN
read -p "GitHub Owner (org or username, e.g., acme): " GITHUB_OWNER
read -p "Team Label (human-readable, e.g., 'Acme Eng (ACE)'): " TEAM_LABEL

# Derive a sane default for GITHUB_REPOSITORY then let the user override.
PROJECT_NAME_LOWER=$(echo "$PROJECT_NAME" | tr '[:upper:] ' '[:lower:]-')
GITHUB_REPO_DEFAULT="${GITHUB_OWNER}/${PROJECT_NAME_LOWER}"
read -p "GitHub Repository [$GITHUB_REPO_DEFAULT]: " GITHUB_REPOSITORY
GITHUB_REPOSITORY="${GITHUB_REPOSITORY:-$GITHUB_REPO_DEFAULT}"

# Optional integrations
echo ""
echo -e "${YELLOW}Integration IDs (press Enter to skip):${NC}"
read -p "Notion Spec Database ID: " NOTION_SPEC_DB
read -p "Notion Wiki Page ID: " NOTION_WIKI_ID
read -p "Linear Team ID: " LINEAR_TEAM_ID
read -p "Linear Workspace slug (for issue URLs): " LINEAR_WORKSPACE

# Replace placeholders in all config files
echo ""
echo -e "${BLUE}Configuring template files...${NC}"

# Function to replace placeholders
replace_placeholders() {
    local file=$1
    if [[ -f "$file" ]]; then
        sed -i.bak "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" "$file"
        sed -i.bak "s/{{PROJECT_DESCRIPTION}}/$PROJECT_DESCRIPTION/g" "$file"
        sed -i.bak "s/{{PROJECT_TYPE}}/$PROJECT_TYPE/g" "$file"
        sed -i.bak "s/{{PROJECT_DOMAIN}}/$PROJECT_DOMAIN/g" "$file"
        sed -i.bak "s/{{GITHUB_OWNER}}/$GITHUB_OWNER/g" "$file"
        # GITHUB_REPOSITORY contains a "/" — use | as delimiter
        sed -i.bak "s|{{GITHUB_REPOSITORY}}|$GITHUB_REPOSITORY|g" "$file"
        # TEAM_LABEL may contain spaces and parens; use | as delimiter
        sed -i.bak "s|{{TEAM_LABEL}}|$TEAM_LABEL|g" "$file"

        # Optional integration IDs: substitute unconditionally with empty-string
        # default so that skipping the prompt still resolves the placeholder.
        # An empty value means "integration disabled"; an unresolved {{TOKEN}}
        # would be read literally by the MCP server and crash it.
        sed -i.bak "s/{{NOTION_SPEC_DATABASE_ID}}/${NOTION_SPEC_DB:-}/g" "$file"
        sed -i.bak "s/{{NOTION_WIKI_PAGE_ID}}/${NOTION_WIKI_ID:-}/g" "$file"
        sed -i.bak "s/{{LINEAR_TEAM_ID}}/${LINEAR_TEAM_ID:-}/g" "$file"
        sed -i.bak "s/{{LINEAR_WORKSPACE}}/${LINEAR_WORKSPACE:-}/g" "$file"

        rm -f "${file}.bak"
        echo -e "  ${GREEN}✓${NC} $file"
    fi
}

# Process all config files (canonical paths only — no root duplicates anymore)
replace_placeholders ".claude/settings.json"
replace_placeholders ".gemini/config.yaml"
replace_placeholders ".gemini/styleguide.md"
replace_placeholders ".continue/config.yaml"
replace_placeholders ".continue/mcpServers/mcp-servers.yaml"
replace_placeholders ".github/copilot-instructions.md"
replace_placeholders ".github/labels.yml"
replace_placeholders "README.md"
replace_placeholders "CONTRIBUTING.md"
replace_placeholders "FORK_AND_CUSTOMIZE.md"

# Wiki content also templated
if [[ -d "docs/wiki" ]]; then
    for wf in docs/wiki/*.md; do
        replace_placeholders "$wf"
    done
fi

# Process all workflows under .github/workflows/
if [[ -d ".github/workflows" ]]; then
    for workflow in .github/workflows/*.yml; do
        replace_placeholders "$workflow"
    done
fi

# Process the optional Astro launcher path if the user kept it
if [[ -d "launcher" ]]; then
    echo ""
    echo -e "${BLUE}Processing launcher/ (Astro SSG starter)...${NC}"
    while IFS= read -r f; do
        replace_placeholders "$f"
    done < <(find launcher -type f \( -name '*.md' -o -name '*.json' -o -name '*.yaml' -o -name '*.yml' -o -name '*.astro' -o -name '*.mjs' -o -name '*.ts' -o -name '*.txt' \) 2>/dev/null)
fi

# Create .env.example
echo ""
echo -e "${BLUE}Creating .env.example...${NC}"
cat > .env.example << 'EOF'
# API Keys
ANTHROPIC_API_KEY=sk-ant-...
GOOGLE_AI_API_KEY=...
VOYAGE_API_KEY=...
PERPLEXITY_API_KEY=pplx-...
BRAVE_API_KEY=...

# Integration Keys
LINEAR_API_KEY=lin_api_...
NOTION_API_KEY=secret_...
GITHUB_TOKEN=ghp_...

# MCP Server Keys
MEM0_API_KEY=...
CONTEXT7_API_KEY=...

# Optional
SENTRY_AUTH_TOKEN=...
VERCEL_TOKEN=...
DATABASE_URL=postgresql://...
EOF
echo -e "  ${GREEN}✓${NC} .env.example created"

# Create .gitignore additions
echo ""
echo -e "${BLUE}Updating .gitignore...${NC}"
cat >> .gitignore << 'EOF'

# Environment files
.env
.env.local
.env.*.local

# IDE
.idea/
.vscode/
*.swp
*.swo

# Dependencies
node_modules/
.pnpm-store/

# Build outputs
dist/
build/
.next/
.nuxt/

# Test coverage
coverage/

# OS files
.DS_Store
Thumbs.db

# Secrets
*.pem
*.key
secrets/

# Continue.dev local
.continue/.cache/
.continue/sessions/
EOF
echo -e "  ${GREEN}✓${NC} .gitignore updated"

# Initialize git if not already
if [[ ! -d ".git" ]]; then
    echo ""
    echo -e "${BLUE}Initializing git repository...${NC}"
    git init
    echo -e "  ${GREEN}✓${NC} Git initialized"
fi

# Summary
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════╗"
echo -e "║     Setup Complete! 🚀                            ║"
echo -e "╚═══════════════════════════════════════════════════╝${NC}"
echo ""

# Final verification
echo -e "${BLUE}Final Verification...${NC}"

# Strict placeholder verification.
#
# Two classes of {{TOKEN}} live in the tree:
#
#   1. Install-time placeholders (e.g. {{PROJECT_NAME}}, {{GITHUB_OWNER}})
#      — these MUST be resolved by the loop above. If any survive, setup
#      did not actually finish; we fail closed.
#
#   2. Runtime tokens — filled in by the AI agent at branch-creation time
#      from per-task context, NOT by setup.sh. These are documented in
#      .github/copilot-instructions.md and must survive setup intact:
#         {{USER}}        — git username, fills at branch creation
#         {{LINEAR_ID}}   — Linear ticket ID (e.g. ACE-123)
#         {{DESCRIPTION}} — branch description slug
#      Plus one optional/commented placeholder:
#         {{VERCEL_PROJECT_ID}} — only resolved if Vercel MCP is enabled
#      And meta-references in docs that describe the placeholder system:
#         {{PLACEHOLDER}}, {{PLACEHOLDERS}}
#
RUNTIME_TOKENS_RE='\{\{(USER|LINEAR_ID|DESCRIPTION|VERCEL_PROJECT_ID|PLACEHOLDER|PLACEHOLDERS)\}\}'

# Find every {{TOKEN}} still in the tree, drop the ones we expect to survive.
LEAKS=$(grep -rEho '\{\{[A-Z_]+\}\}' \
            --exclude-dir=node_modules \
            --exclude-dir=.git \
            --exclude=setup.sh \
            --exclude=.gitignore \
            . 2>/dev/null \
        | grep -vE "$RUNTIME_TOKENS_RE" \
        | sort -u || true)

if [[ -n "$LEAKS" ]]; then
    echo -e "${RED}✗ Setup incomplete — install-time placeholders still present:${NC}"
    while IFS= read -r tok; do
        echo "    $tok"
        grep -rn --fixed-strings "$tok" . \
            --exclude-dir=node_modules --exclude-dir=.git \
            --exclude=setup.sh --exclude=.gitignore 2>/dev/null \
            | head -3 | sed "s|^|      |"
    done <<< "$LEAKS"
    echo -e "${RED}   Setup did not finish cleanly. Re-run ./setup.sh or patch by hand.${NC}"
else
    echo -e "${GREEN}✓ All install-time placeholders resolved${NC}"
    echo -e "  ${BLUE}(runtime tokens like {{USER}}, {{LINEAR_ID}}, {{DESCRIPTION}} are intentionally retained)${NC}"
fi

# Verify git remote
if [[ -d ".git" ]]; then
    FINAL_REMOTE=$(git remote get-url origin 2>/dev/null || echo "not set")
    if [[ "$FINAL_REMOTE" == *"clduab11/repo-skeletor"* ]]; then
        echo -e "${RED}✗ WARNING: Git remote still points to template!${NC}"
        echo "  You MUST change this before pushing: git remote set-url origin YOUR_URL"
    else
        echo -e "${GREEN}✓ Git remote: $FINAL_REMOTE${NC}"
    fi
fi

echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Copy .env.example to .env and fill in your API keys"
echo "2. Add secrets to GitHub repository settings"
echo "3. Verify git remote: git remote -v"
echo "4. Install dependencies: pnpm install"
echo "5. Start coding!"
echo ""
echo -e "${BLUE}Required GitHub Secrets:${NC}"
echo "  - ANTHROPIC_API_KEY"
echo "  - LINEAR_API_KEY"
echo "  - NOTION_API_KEY"
echo "  - LINEAR_TEAM_ID"
echo "  - NOTION_SPEC_DATABASE_ID"
echo ""
echo -e "${RED}BEFORE FIRST PUSH:${NC}"
echo -e "${RED}   Verify with: git remote -v${NC}"
echo -e "${RED}   Should show YOUR repository, NOT clduab11/repo-skeletor${NC}"
echo ""
echo -e "${GREEN}Happy coding!${NC}"
echo ""
echo "For help, see:"
echo "   - docs/wiki/Proper-Template-Usage.md"
echo "   - docs/wiki/Common-Mistakes.md"
r-Template-Usage.md"
echo "   - docs/wiki/Quick-Start-Guide.md"
echo "   - docs/wiki/Customization-Guide.md"
echo "   - docs/wiki/Common-Mistakes.md"
echo ""
