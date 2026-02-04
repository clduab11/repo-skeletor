#!/bin/bash
# Repo Template Setup Script
# Parallax Analytics

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════╗"
echo "║     Repo Template Setup                           ║"
echo "║     Parallax Analytics                            ║"
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

# Optional integrations
echo ""
echo -e "${YELLOW}Integration IDs (press Enter to skip):${NC}"
read -p "Notion Spec Database ID: " NOTION_SPEC_DB
read -p "Notion Wiki Page ID: " NOTION_WIKI_ID
read -p "Linear Team ID: " LINEAR_TEAM_ID

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

        if [[ -n "$NOTION_SPEC_DB" ]]; then
            sed -i.bak "s/{{NOTION_SPEC_DATABASE_ID}}/$NOTION_SPEC_DB/g" "$file"
        fi
        if [[ -n "$NOTION_WIKI_ID" ]]; then
            sed -i.bak "s/{{NOTION_WIKI_PAGE_ID}}/$NOTION_WIKI_ID/g" "$file"
        fi
        if [[ -n "$LINEAR_TEAM_ID" ]]; then
            sed -i.bak "s/{{LINEAR_TEAM_ID}}/$LINEAR_TEAM_ID/g" "$file"
        fi

        rm -f "${file}.bak"
        echo -e "  ${GREEN}✓${NC} $file"
    fi
}

# Process all config files
replace_placeholders "settings.json"
replace_placeholders ".claude/settings.json"
replace_placeholders ".gemini/config.yaml"
replace_placeholders ".gemini/styleguide.md"
replace_placeholders ".continue/config.yaml"
replace_placeholders ".continue/mcpServers/mcp-servers.yaml"
replace_placeholders "README.md"

# Process workflow files if they exist in root
for workflow in ci.yml claude.yml deploy.yml linear-to-notion-sync.yml notion-spec-to-linear.yml; do
    if [[ -f "$workflow" ]]; then
        replace_placeholders "$workflow"
    fi
done

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

# Check for remaining placeholders
PLACEHOLDER_COUNT=$(grep -r "{{PROJECT_NAME}}" . --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=template 2>/dev/null | wc -l || echo "0")
if [[ "$PLACEHOLDER_COUNT" -gt 0 ]]; then
    echo -e "${YELLOW}⚠️  Warning: Some placeholders may not have been replaced.${NC}"
    echo "   Run: grep -r '{{PROJECT_NAME}}' . --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=template"
else
    echo -e "${GREEN}✓ All placeholders replaced successfully${NC}"
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
echo -e "${RED}⚠️  BEFORE FIRST PUSH:${NC}"
echo -e "${RED}   Verify with: git remote -v${NC}"
echo -e "${RED}   Should show YOUR repository, NOT clduab11/repo-skeletor${NC}"
echo ""
echo -e "${GREEN}Happy coding! 🎉${NC}"
echo ""
echo "📖 For help, see:"
echo "   - docs/wiki/Proper-Template-Usage.md"
echo "   - docs/wiki/Common-Mistakes.md"

