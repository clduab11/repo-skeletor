#!/bin/bash

# repo-skeletor Setup Script
# This script sets up the development environment for solo dev workflow
# integrating Claude Code, Gemini, Continue.dev, Linear, and Notion

set -e

echo "=========================================="
echo "  repo-skeletor Setup"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running in a git repository
if [ ! -d .git ]; then
    print_error "This script must be run from the root of a git repository"
    exit 1
fi

print_info "Checking prerequisites..."

# Check for required tools
command -v git >/dev/null 2>&1 || { print_error "git is required but not installed. Aborting."; exit 1; }
command -v curl >/dev/null 2>&1 || { print_error "curl is required but not installed. Aborting."; exit 1; }

print_info "Prerequisites OK"
echo ""

# Check for environment variables / secrets
print_info "Checking for required secrets..."
echo ""

MISSING_SECRETS=0

if [ -z "$ANTHROPIC_API_KEY" ]; then
    print_warn "ANTHROPIC_API_KEY is not set"
    MISSING_SECRETS=1
fi

if [ -z "$LINEAR_API_KEY" ]; then
    print_warn "LINEAR_API_KEY is not set"
    MISSING_SECRETS=1
fi

if [ -z "$NOTION_API_KEY" ]; then
    print_warn "NOTION_API_KEY is not set"
    MISSING_SECRETS=1
fi

if [ -z "$LINEAR_TEAM_ID" ]; then
    print_warn "LINEAR_TEAM_ID is not set"
    MISSING_SECRETS=1
fi

if [ -z "$NOTION_SPEC_DATABASE_ID" ]; then
    print_warn "NOTION_SPEC_DATABASE_ID is not set"
    MISSING_SECRETS=1
fi

if [ $MISSING_SECRETS -eq 1 ]; then
    echo ""
    print_warn "Some secrets are missing. Please set them as environment variables or GitHub secrets."
    echo ""
    echo "Required secrets:"
    echo "  - ANTHROPIC_API_KEY: Your Anthropic API key for Claude"
    echo "  - LINEAR_API_KEY: Your Linear API key"
    echo "  - NOTION_API_KEY: Your Notion integration token"
    echo "  - LINEAR_TEAM_ID: Your Linear team ID"
    echo "  - NOTION_SPEC_DATABASE_ID: Your Notion database ID for specs"
    echo ""
    echo "You can set them in your shell profile or add them to GitHub repository secrets."
    echo ""
else
    print_info "All required secrets are configured"
fi

# Create .env.example file
print_info "Creating .env.example file..."
cat > .env.example << EOF
# Anthropic API Key for Claude
ANTHROPIC_API_KEY=your_anthropic_api_key_here

# Gemini API Key (optional)
GEMINI_API_KEY=your_gemini_api_key_here

# Linear Integration
LINEAR_API_KEY=your_linear_api_key_here
LINEAR_TEAM_ID=your_linear_team_id_here

# Notion Integration
NOTION_API_KEY=your_notion_api_key_here
NOTION_SPEC_DATABASE_ID=your_notion_database_id_here
EOF

print_info ".env.example created"

# Check if .env file exists
if [ -f .env ]; then
    print_warn ".env file already exists, skipping creation"
else
    print_info "Creating .env file from template..."
    cp .env.example .env
    print_warn "Please edit .env file and add your actual API keys"
fi

echo ""
print_info "Verifying directory structure..."

# Verify required directories exist
DIRS=(".claude" ".gemini" ".github/workflows" ".continue")
for dir in "${DIRS[@]}"; do
    if [ -d "$dir" ]; then
        print_info "✓ $dir exists"
    else
        print_warn "✗ $dir does not exist, creating..."
        mkdir -p "$dir"
    fi
done

echo ""
print_info "Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env file with your actual API keys (don't commit this file!)"
echo "2. Add secrets to your GitHub repository:"
echo "   - Go to Settings > Secrets and variables > Actions"
echo "   - Add the required secrets listed above"
echo "3. Enable GitHub Actions in your repository settings"
echo "4. Install Continue.dev extension in VS Code"
echo "5. Configure your AI tools according to the configs in .claude/, .gemini/, and .continue/"
echo ""
echo "For more information, see README.md"
echo ""
