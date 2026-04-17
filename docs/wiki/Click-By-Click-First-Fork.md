# Click-By-Click First Fork

A literal, screen-by-screen walkthrough for people whose tech baseline is "I just ran my first Docker container and want to use MCPs without breaking things."

No prior GitHub, pnpm, or Node experience assumed. Follow top to bottom. If something looks different from a screenshot because GitHub shipped a UI tweak last week, the button names are stable — look for the words in **bold**.

---

## Prerequisites: installers, not concepts

Install these one time before you start. Pick the tab matching your OS.

### macOS

1. Open **Terminal** (Cmd-Space → type "Terminal" → Enter).
2. Install Homebrew (the macOS package manager) by pasting this and hitting Enter:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
3. With Homebrew installed, install the tools:
   ```bash
   brew install git gh node pnpm pre-commit
   ```
4. Install the two AI CLIs:
   ```bash
   npm i -g @anthropic-ai/claude-code
   npm i -g @openai/codex
   ```

### Windows

1. Install **WSL2 with Ubuntu** from PowerShell (run as Administrator):
   ```powershell
   wsl --install -d Ubuntu
   ```
   Reboot when prompted. On next login, Ubuntu will open and ask you to set a username + password.
2. Inside the Ubuntu terminal, install the tools:
   ```bash
   sudo apt update && sudo apt install -y git curl ca-certificates
   curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
   sudo apt install -y nodejs
   sudo npm i -g pnpm
   sudo apt install -y pre-commit gh
   ```
3. Install the AI CLIs:
   ```bash
   sudo npm i -g @anthropic-ai/claude-code
   sudo npm i -g @openai/codex
   ```

### Linux (Ubuntu / Debian)

Use the Windows-WSL block above, skipping step 1.

### Verify everything works

```bash
git --version        # any 2.x
gh --version         # any 2.x
node --version       # v20+ preferred
pnpm --version       # any 8.x+
pre-commit --version # any 3.x+
claude --version
codex --version
```

If any command returns "command not found," scroll up — one of the installers didn't finish. Fix that before moving on.

---

## Step 1: Create your API keys

You need four accounts + four keys before the first push. Do this once, save them in a password manager, reuse forever.

| Service | Account URL | Key URL | Format |
|---|---|---|---|
| Anthropic | <https://console.anthropic.com> | **API Keys** → **Create Key** | `sk-ant-api03-...` |
| OpenAI | <https://platform.openai.com> | **API keys** → **Create new secret key** | `sk-proj-...` or `sk-...` |
| Linear | <https://linear.app> | **Settings** → **API** → **Personal API keys** → **New API key** | `lin_api_...` |
| Notion | <https://www.notion.so> | <https://www.notion.so/my-integrations> → **New integration** → Internal | `secret_...` or `ntn_...` |
| GitHub | <https://github.com> | **Settings** → **Developer settings** → **Personal access tokens (classic)** → **Generate new token (classic)** with scopes `repo`, `workflow`, `read:org` | `ghp_...` |

Save each key the moment it's shown on screen — none of them can be re-displayed later.

---

## Step 2: "Use this template" — the click-by-click

This is the one step people get wrong. **Do not `git clone` repo-skeletor directly.** Use the template button so GitHub creates a fresh repo under your account.

1. Open <https://github.com/clduab11/repo-skeletor> in your browser.
2. Look at the top-right corner of the repo page. Find the green **Use this template** button. It's beside the "Code" button.
3. Click **Use this template** → a dropdown opens → click **Create a new repository**.
4. GitHub takes you to the "Create a new repository from repo-skeletor" page:
   - **Owner**: pick your user or an org you own.
   - **Repository name**: lowercase, hyphens OK (e.g., `my-first-ai-project`).
   - **Description**: one sentence about what you're building. Optional but helpful.
   - **Public** vs **Private**: pick **Private** for your first try. You can flip it later.
   - Leave **Include all branches** unchecked.
5. Click the green **Create repository** button at the bottom.
6. Wait 3–5 seconds. GitHub drops you at your new repo page. Confirm the URL in your address bar ends with `/<your-username>/<your-repo-name>`, not `/clduab11/repo-skeletor`.

If the URL still says `clduab11/repo-skeletor`, close the tab and start over — you're about to push to someone else's template and the pre-commit hooks will reject you.

---

## Step 3: Clone YOUR new repo to your machine

1. On your new repo page, click the green **Code** button.
2. In the dropdown, confirm **HTTPS** is selected (not SSH, not GitHub CLI — HTTPS is easiest for first-timers).
3. Click the copy icon next to the URL. It looks like `https://github.com/<your-username>/<your-repo>.git`.
4. Back in your terminal:
   ```bash
   cd ~                                  # or wherever you keep code
   git clone https://github.com/<your-username>/<your-repo>.git
   cd <your-repo>
   ```
5. When git asks for a password, paste your **GitHub personal access token** (`ghp_...`), not your GitHub password. GitHub turned off password auth in 2021.

Verify you're in the right place:
```bash
git remote -v
# origin https://github.com/<your-username>/<your-repo>.git (fetch)
# origin https://github.com/<your-username>/<your-repo>.git (push)
```
If this shows `clduab11/repo-skeletor`, stop and redo Step 2.

---

## Step 4: Run `./setup.sh`

This interactive script replaces every `{{PROJECT_NAME}}` / `{{PROJECT_DESCRIPTION}}` / `{{PROJECT_TYPE}}` placeholder with your answers and writes the bootstrap files.

```bash
./setup.sh
```

It asks five questions. Plausible answers:

| Prompt | Example answer |
|---|---|
| Project name | `my-first-ai-project` |
| Project description | `Personal sandbox for MCP experiments` |
| Project type (web-app / api / cli / library) | `web-app` |
| Author name | `Jane Doe` |
| Author email | `jane@example.com` |

When it finishes you'll see "Setup complete!" and a list of next steps. Don't skip them.

---

## Step 5: Fill in `.env` with your API keys

```bash
cp .env.example .env
```

Open `.env` in any editor (`nano .env`, `code .env`, `vim .env` — pick your poison) and paste in the keys from Step 1. The file shouldn't ever be committed — `.gitignore` already excludes it.

---

## Step 6: Install pre-commit hooks

This guards you against committing secrets, broken YAML, or leftover `{{PLACEHOLDERS}}`.

```bash
./scripts/install-hooks.sh
```

You'll see it install hooks for `pre-commit`, `commit-msg`, and `pre-push`. First run takes ~30 seconds while it downloads hook environments.

---

## Step 7: Add GitHub Secrets (for the Actions)

The `@claude` workflow needs `ANTHROPIC_API_KEY` available inside Actions. Add the four required secrets:

```bash
gh auth login                                         # one-time: follow the browser prompts
gh secret set ANTHROPIC_API_KEY                       # paste when prompted
gh secret set OPENAI_API_KEY
gh secret set LINEAR_API_KEY
gh secret set NOTION_API_KEY
```

Or via the UI: **Settings** → **Secrets and variables** → **Actions** → **New repository secret**. Add all four with the same names above.

---

## Step 8: Apply branch protection

Don't skip this — without it you can accidentally push broken `main`.

```bash
./scripts/apply-branch-protection.sh
```

The script reads `.github/branch-protection.json` and calls the GitHub API. It asks for a 3-second confirm window before applying. After it runs, `main` requires: passing CI, 1 approving review, linear history, no force pushes, no deletions.

---

## Step 9: First commit and push

```bash
git add -A
git commit -m "chore: initial setup for my-first-ai-project"
git push origin main
```

Pre-commit will run all hooks on the diff. If it rejects the commit, read the output — usually it's a trailing-whitespace or merge-conflict marker, trivial to fix. Re-run `git add -A && git commit ...` after fixing.

Now check your repo page on GitHub → **Actions** tab. You should see the CI workflow running on your push.

---

## When things go wrong

| Symptom | Likely cause | Fix |
|---|---|---|
| `remote: Support for password authentication was removed` | Using GitHub password instead of PAT | Paste your `ghp_...` token as the password |
| `pre-commit: command not found` | `pre-commit` not installed | Rerun the OS-specific install step above |
| CI fails with "Secret ANTHROPIC_API_KEY not found" | Forgot Step 7 | Add secrets via `gh secret set` |
| `setup.sh: Permission denied` | Not executable | `chmod +x setup.sh scripts/*.sh` |
| `@claude` doesn't respond on a PR comment | Workflow disabled or secret missing | Check **Actions** tab; verify `ANTHROPIC_API_KEY` secret |
| Commit rejected: "found potential secret" | gitleaks caught a key in the diff | Remove the key, put it in `.env`, recommit |
| Commit rejected: "placeholder `{{XYZ}}` found" | `setup.sh` missed a file | Rerun `./setup.sh` or hand-edit the flagged file |

---

## What's next

You have a working template. From here:

- Read **[Template Structure](./Template-Structure.md)** to understand what's in the repo.
- Read **[Customization Guide](./Customization-Guide.md)** to tailor slash commands, subagents, and the MCP catalog.
- Read **[Secrets & Environment Setup](./Secrets-and-Environment-Setup.md)** for the full secret matrix.
- Read **[Common Mistakes](./Common-Mistakes.md)** before you make them.

Open your first PR with `@claude please review` in a comment. The AI review workflow will respond with line-specific feedback.
