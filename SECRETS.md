# Secrets Configuration Guide

This document provides detailed instructions for setting up the required API keys and secrets for repo-skeletor.

## Required Secrets

### 1. ANTHROPIC_API_KEY

**Purpose**: Used for Claude AI integration

**How to get it**:
1. Sign up at [Anthropic Console](https://console.anthropic.com/)
2. Go to "API Keys" section
3. Click "Create Key"
4. Copy the key and store it securely
5. Add to GitHub Secrets or `.env` file

**Usage**: Claude Code, Continue.dev

---

### 2. LINEAR_API_KEY

**Purpose**: Used for Linear issue tracking integration

**How to get it**:
1. Go to [Linear Settings > API](https://linear.app/settings/api)
2. Click "Create new API key"
3. Give it a descriptive name (e.g., "repo-skeletor")
4. Copy the key immediately (it won't be shown again)
5. Add to GitHub Secrets or `.env` file

**Usage**: GitHub Actions Linear sync workflow

---

### 3. LINEAR_TEAM_ID

**Purpose**: Identifies which Linear team to sync with

**How to get it**:
1. Go to Linear workspace
2. Navigate to Settings > General
3. Note your team identifier (usually visible in URLs)
4. Alternative: Use Linear API GraphQL playground:
   ```graphql
   query {
     teams {
       nodes {
         id
         name
         key
       }
     }
   }
   ```
5. Add to GitHub Secrets or `.env` file

**Usage**: GitHub Actions Linear sync workflow

---

### 4. NOTION_API_KEY

**Purpose**: Used for Notion documentation integration

**How to get it**:
1. Go to [Notion Integrations](https://www.notion.so/my-integrations)
2. Click "+ New integration"
3. Name it (e.g., "repo-skeletor")
4. Select the workspace
5. Submit and copy the "Internal Integration Token"
6. Share your database with this integration:
   - Open your Notion database
   - Click "..." menu
   - Select "Add connections"
   - Find and add your integration

**Usage**: GitHub Actions Notion sync workflow

---

### 5. NOTION_SPEC_DATABASE_ID

**Purpose**: Identifies which Notion database to sync with

**How to get it**:
1. Open your Notion database
2. Click "..." menu > "Copy link"
3. The URL looks like: `https://www.notion.so/workspace/DATABASE_ID?v=...`
4. Extract the `DATABASE_ID` (32-character string)
5. Example: `https://notion.so/12345abcde67890fghij12345abcde67` → `12345abcde67890fghij12345abcde67`

**Alternative method**:
1. Open database
2. Click "Share"
3. "Copy link"
4. Extract ID from URL

**Usage**: GitHub Actions Notion sync workflow

---

## Setting Up GitHub Secrets

1. Go to your repository on GitHub
2. Click "Settings" tab
3. Navigate to "Secrets and variables" > "Actions"
4. Click "New repository secret"
5. Add each secret:
   - Name: `ANTHROPIC_API_KEY`
   - Value: Your actual API key
   - Click "Add secret"
6. Repeat for all 5 required secrets

## Setting Up Local Development

For local development, create a `.env` file:

```bash
cp .env.example .env
```

Then edit `.env` with your actual values. **Never commit this file!**

## Verifying Setup

Run the setup script to verify all secrets are configured:

```bash
./setup.sh
```

The script will check for missing environment variables and guide you through the setup.

## Security Best Practices

1. **Never commit** API keys to the repository
2. **Rotate keys** regularly (every 90 days recommended)
3. **Use separate keys** for development and production
4. **Limit permissions** on API keys to only what's needed
5. **Monitor usage** of your API keys
6. **Revoke immediately** if a key is compromised

## Troubleshooting

### "API key invalid" errors

- Verify the key is copied correctly (no extra spaces)
- Check if the key has expired
- Ensure proper permissions are set

### "Team not found" in Linear

- Verify LINEAR_TEAM_ID is correct
- Check if API key has access to the team
- Try getting team ID via API

### "Database not found" in Notion

- Verify database ID is correct (32 characters, no dashes)
- Ensure integration is connected to the database
- Check if integration has proper permissions

### Secrets not working in GitHub Actions

- Verify secrets are added to repository settings
- Check secret names match exactly (case-sensitive)
- Ensure workflows have proper permissions

## Additional Resources

- [Anthropic API Documentation](https://docs.anthropic.com/)
- [Linear API Documentation](https://developers.linear.app/)
- [Notion API Documentation](https://developers.notion.com/)
- [GitHub Actions Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

---

For questions or issues, please open a GitHub issue.
