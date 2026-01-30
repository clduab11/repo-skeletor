# GitHub Actions Workflows

This directory contains automated workflows for repo-skeletor.

## Available Workflows

### 1. CI (Continuous Integration)

**File**: `ci.yml`

**Triggers**:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches

**Jobs**:
- **Lint**: Runs code linting (if configured in package.json)
- **Test**: Runs test suite (if configured in package.json)

**Purpose**: Ensures code quality and tests pass before merging.

---

### 2. Linear Sync

**File**: `linear-sync.yml`

**Triggers**:
- Issues: opened, edited, closed, reopened
- Issue comments: created
- Pull requests: opened, edited, closed, reopened, merged

**Jobs**:
- **sync-to-linear**: Syncs GitHub issues and PRs to Linear

**Required Secrets**:
- `LINEAR_API_KEY`
- `LINEAR_TEAM_ID`
- `GITHUB_TOKEN` (automatically provided)

**Purpose**: Maintains bi-directional sync between GitHub and Linear for issue tracking.

**How it works**:
1. When a GitHub issue is created, a Linear issue is created
2. Updates in GitHub are reflected in Linear
3. Links are maintained between both systems

---

### 3. Notion Sync

**File**: `notion-sync.yml`

**Triggers**:
- Push to `main` branch
- Pull requests: opened, edited, closed, merged
- Issues: opened, edited, closed

**Jobs**:
- **sync-to-notion**: Creates documentation pages in Notion

**Required Secrets**:
- `NOTION_API_KEY`
- `NOTION_SPEC_DATABASE_ID`

**Purpose**: Automatically documents changes and maintains a knowledge base in Notion.

**How it works**:
1. Creates Notion pages for PRs and issues
2. Includes links back to GitHub
3. Updates database with current status

---

## Setting Up Workflows

### 1. Add Required Secrets

Go to: `Settings` → `Secrets and variables` → `Actions`

Add these secrets:
- `ANTHROPIC_API_KEY`
- `LINEAR_API_KEY`
- `LINEAR_TEAM_ID`
- `NOTION_API_KEY`
- `NOTION_SPEC_DATABASE_ID`

See [SECRETS.md](../../SECRETS.md) for detailed instructions.

### 2. Enable GitHub Actions

Go to: `Settings` → `Actions` → `General`

Select: "Allow all actions and reusable workflows"

### 3. Test Workflows

Create a test issue or PR to verify workflows run correctly:

```bash
# Create test issue
gh issue create --title "Test Issue" --body "Testing Linear sync"

# Create test PR
git checkout -b test-branch
echo "test" > test.txt
git add test.txt
git commit -m "Test commit"
git push origin test-branch
gh pr create --title "Test PR" --body "Testing Notion sync"
```

## Viewing Workflow Runs

### In GitHub UI

1. Go to "Actions" tab
2. Click on a workflow
3. Select a run to view details
4. Click on jobs to see logs

### Using GitHub CLI

```bash
# List recent runs
gh run list

# View specific run
gh run view <run-id>

# View run logs
gh run view <run-id> --log

# Watch live run
gh run watch
```

## Troubleshooting

### Workflow not triggering

- Check if Actions are enabled in repository settings
- Verify workflow syntax with: `gh workflow list`
- Check branch protection rules

### "Secrets not found" error

- Verify secrets are added to repository settings
- Check secret names match exactly (case-sensitive)
- Wait a few minutes after adding secrets

### Linear sync failing

- Verify `LINEAR_API_KEY` is valid
- Check `LINEAR_TEAM_ID` is correct
- Test Linear API manually:
  ```bash
  curl -X POST https://api.linear.app/graphql \
    -H "Authorization: YOUR_KEY" \
    -H "Content-Type: application/json" \
    -d '{"query": "query { viewer { id name email } }"}'
  ```

### Notion sync failing

- Verify `NOTION_API_KEY` is valid
- Check `NOTION_SPEC_DATABASE_ID` is correct (32 characters)
- Ensure Notion integration is connected to database
- Test Notion API:
  ```bash
  curl -X GET https://api.notion.com/v1/databases/YOUR_DB_ID \
    -H "Authorization: Bearer YOUR_KEY" \
    -H "Notion-Version: 2022-06-28"
  ```

## Customizing Workflows

### Modifying Triggers

Edit the `on:` section in workflow files:

```yaml
on:
  push:
    branches: [ main, develop, feature/* ]
  schedule:
    - cron: '0 0 * * *'  # Daily at midnight
```

### Adding New Jobs

Add new jobs in the workflow file:

```yaml
jobs:
  existing-job:
    # ... existing job config
    
  new-job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run custom script
        run: ./scripts/my-script.sh
```

### Using Actions from Marketplace

Browse [GitHub Actions Marketplace](https://github.com/marketplace?type=actions) and add to workflows:

```yaml
- name: Use marketplace action
  uses: actions/some-action@v1
  with:
    parameter: value
```

## Best Practices

1. **Test locally**: Use [act](https://github.com/nektos/act) to test workflows locally
2. **Keep secrets secure**: Never log or expose secrets in workflows
3. **Use specific versions**: Pin action versions (e.g., `@v4` not `@latest`)
4. **Add timeouts**: Prevent workflows from running too long
5. **Cache dependencies**: Speed up workflows with caching

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [Linear API Documentation](https://developers.linear.app/)
- [Notion API Documentation](https://developers.notion.com/)

---

For issues or questions about workflows, open a GitHub issue.
