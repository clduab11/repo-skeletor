# Contributing to repo-skeletor

Thank you for your interest in contributing to the repo-skeletor template! This document explains how to contribute improvements to the **template itself**, not to projects created from it.

---

## 🎯 What is repo-skeletor?

`repo-skeletor` is a **template repository** for creating new projects with AI-augmented development workflows. It provides pre-configured setups for:

- Claude Code
- Gemini AI
- Continue.dev
- Linear
- Notion
- GitHub Actions

---

## ⚠️ Important Distinction

### Contributing to the Template (this repo)

You're in the right place if you want to:
- ✅ Improve template configuration files
- ✅ Add new workflow templates
- ✅ Enhance the setup script
- ✅ Fix template documentation
- ✅ Add new AI assistant configurations

### Contributing to a Project (NOT here)

If you cloned this template to create a project and want to contribute to **your project**, this is **not** the right place. Contribute to your project's repository instead.

---

## 🚀 Getting Started

### Prerequisites

- Git
- GitHub account
- Bash (for testing setup.sh)
- Basic understanding of the technologies used in the template

### Fork and Clone

1. **Fork this repository** on GitHub
2. **Clone your fork:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/repo-skeletor.git
   cd repo-skeletor
   ```
3. **Add upstream remote:**
   ```bash
   git remote add upstream https://github.com/clduab11/repo-skeletor.git
   ```

---

## 📋 Contribution Guidelines

### Types of Contributions

#### 🐛 Bug Reports

Found a bug in the template? Create an issue:

1. Go to [Issues](https://github.com/clduab11/repo-skeletor/issues)
2. Click "New Issue"
3. Use the bug report template
4. Provide:
   - Clear description of the bug
   - Steps to reproduce
   - Expected vs. actual behavior
   - System information (OS, shell, etc.)

#### 💡 Feature Requests

Have an idea for improving the template?

1. Create an issue with the feature request template
2. Explain:
   - What problem does this solve?
   - How would it work?
   - Are there alternatives?
   - Would you be willing to implement it?

#### 📝 Documentation Improvements

Documentation can always be better:

- Fix typos or unclear explanations
- Add examples or diagrams
- Improve organization
- Add missing information

#### 🔧 Code Contributions

Improvements to template configuration or scripts:

- Enhance setup.sh
- Improve workflow templates
- Add new AI configurations
- Optimize existing configurations

---

## 🛠️ Development Workflow

### 1. Create a Branch

```bash
# Fetch latest changes
git fetch upstream
git checkout main
git merge upstream/main

# Create a feature branch
git checkout -b feature/your-feature-name
# or for bugs: git checkout -b fix/bug-description
```

### 2. Make Your Changes

**For template configuration changes:**
- Edit files in the root directory (`.claude/`, `.gemini/`, etc.)
- Update `template/` directory to match
- Ensure placeholders like `{{PROJECT_NAME}}` are preserved

**For setup script changes:**
- Edit `setup.sh`
- Update `template/setup.sh` to match
- Test on multiple platforms if possible (Linux, macOS, Windows/Git Bash)

**For documentation changes:**
- Edit files in `docs/wiki/`
- Keep formatting consistent
- Update table of contents if needed
- Check for broken links

### 3. Test Your Changes

**Test the setup process:**
```bash
# In a test directory (not in repo-skeletor)
cd /tmp
mkdir test-project
cd test-project

# Copy template files
cp -r /path/to/repo-skeletor/{.claude,.gemini,.continue,setup.sh,settings.json,*.yml} .

# Run setup
./setup.sh

# Verify placeholders were replaced
grep -r "{{PROJECT_NAME}}" .

# Should only appear in template/ directory
```

**Test workflows:**
- Use GitHub's workflow syntax checker
- Test manually if possible

**Test documentation:**
- Read through your changes
- Check markdown rendering
- Verify all links work

### 4. Commit Your Changes

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```bash
# Stage your changes
git add .

# Commit with conventional format
git commit -m "feat(setup): add remote URL verification"
git commit -m "fix(workflows): correct template-protection check"
git commit -m "docs(wiki): add troubleshooting section"
```

**Commit types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, no code change
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance

**Scope examples:**
- `setup`: setup.sh script
- `workflows`: GitHub Actions
- `config`: Configuration files
- `docs`: Documentation
- `wiki`: Wiki documentation

### 5. Push and Create PR

```bash
# Push to your fork
git push origin feature/your-feature-name
```

**Create Pull Request:**
1. Go to your fork on GitHub
2. Click "New Pull Request"
3. Fill in the PR template:
   - **Title:** Clear, descriptive summary
   - **Description:** What changes, why, how
   - **Testing:** How you tested
   - **Screenshots:** If UI/docs changes
4. Link related issues

---

## ✅ PR Review Process

### What to Expect

1. **Automated Checks:**
   - Template protection workflow runs
   - Validates template structure
   - Checks for project-specific content

2. **Manual Review:**
   - Maintainers review your code
   - May request changes
   - May ask questions

3. **Approval:**
   - Once approved, PR is merged
   - Your changes are in the next release

### Review Checklist

Before submitting, verify:

- [ ] Placeholders (`{{PROJECT_NAME}}`, etc.) are preserved
- [ ] `template/` directory matches root files
- [ ] `setup.sh` is tested and working
- [ ] Documentation is clear and accurate
- [ ] Commit messages follow conventional commits
- [ ] No secrets or sensitive data included
- [ ] No project-specific content
- [ ] All new files have appropriate content

---

## 🚫 What NOT to Contribute

### ❌ Project-Specific Content

Don't submit:
- Content specific to YOUR project
- Filled-in placeholder values
- Project code (this is a template!)
- Private/internal configurations

Example of **wrong** contribution:
```json
{
  "project": {
    "name": "my-awesome-api"  // ❌ Should be {{PROJECT_NAME}}
  }
}
```

Example of **correct** contribution:
```json
{
  "project": {
    "name": "{{PROJECT_NAME}}"  // ✅ Placeholder preserved
  }
}
```

### ❌ Unrelated Features

Don't submit:
- Features unrelated to AI-augmented development
- Language-specific build configs (unless generic)
- Opinionated code style (keep it configurable)
- Large dependencies

---

## 📝 Style Guide

### Shell Scripts

```bash
# Use bash, not sh
#!/bin/bash

# Set error handling
set -e

# Use descriptive variable names
PROJECT_NAME=""
not: pn=""

# Quote variables
echo "$PROJECT_NAME"
not: echo $PROJECT_NAME

# Use functions for complex logic
function replace_placeholders() {
  # ...
}
```

### YAML (Workflows)

```yaml
# Use descriptive names
name: Template Protection
not: name: check

# Add comments for complex logic
# Check for project-specific content
steps:
  - name: Clear step description

# Use consistent indentation (2 spaces)
jobs:
  check:
    runs-on: ubuntu-latest
```

### Markdown (Documentation)

```markdown
# Use proper heading hierarchy
## Level 2
### Level 3

# Use code blocks with language
```bash
# Not: ```
git commit -m "message"
```

# Use lists for steps
1. First step
2. Second step

# Use checkboxes for checklists
- [ ] Todo item
- [x] Completed item
```

---

## 🏷️ Issue Labels

Issues and PRs are labeled for organization:

- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Documentation improvements
- `question` - Further information requested
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `wontfix` - Won't be worked on
- `duplicate` - Already reported
- `invalid` - Not a valid issue

---

## 🎉 Recognition

Contributors are recognized in:
- GitHub's contributor list
- Release notes (for significant contributions)
- Documentation (where applicable)

---

## 📞 Getting Help

Need help contributing?

- **Questions:** Create a discussion or issue
- **Chat:** Coming soon - Discord server
- **Email:** Check repository owner's profile

---

## 📄 License

By contributing, you agree that your contributions will be licensed under the same license as this project (see [LICENSE](./LICENSE)).

---

## 🙏 Thank You!

Your contributions help make repo-skeletor better for everyone. Whether you're fixing a typo or adding a major feature, every contribution is valued!

---

**See Also:**
- [Proper Template Usage](./docs/wiki/Proper-Template-Usage.md) - How to use the template
- [Common Mistakes](./docs/wiki/Common-Mistakes.md) - What to avoid
- [Quick Start Guide](./docs/wiki/Quick-Start-Guide.md) - Getting started
