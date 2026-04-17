# Fork & Customize

How to take `repo-skeletor` from "I clicked Use this template" to "I'm shipping commits" in 15 minutes.

This is the walkthrough for downstream consumers — clone YOUR new repo, run `./setup.sh`, push.

---

## Prerequisites

| Tool | Why | Install |
|---|---|---|
| `git` ≥ 2.40 | Everything | https://git-scm.com |
| `gh` (GitHub CLI) | Secrets, repo creation, label sync | https://cli.github.com |
| Node ≥ 20 | Launcher path only | https://nodejs.org |
| Linear account | Sync workflows | https://linear.app |
| Notion account | Sync workflows | https://notion.so |
| Anthropic API key | Claude Code + `claude.yml` workflow | https://console.anthropic.com |
| OpenAI API key | Codex CLI (optional) | https://platform.openai.com |
| `pre-commit` | Commit/push guards | https://pre-commit.com (installer: `./scripts/install-hooks.sh`) |

You can skip Linear/Notion/Anthropic/OpenAI and the matching workflows will simply no-op — they fail closed without secrets.

---

## Step 1 — Create your repo from the template

On GitHub: navigate to `https://github.com/clduab11/repo-skeletor` → click **Use this template** → **Create a new repository**.

Do **not** `git clone` the template. The `template-protection.yml` workflow exists specifically because someone always tries.

---

## Step 2 — Clone YOUR repo

```bash
git clone https://github.com/YOU/your-project.git
cd your-project
```

Verify the remote does NOT point at `clduab11/repo-skeletor`:

```bash
git remote -v
# origin  https://github.com/YOU/your-project.git (fetch)
# origin  https://github.com/YOU/your-project.git (push)
```

If you see `clduab11/repo-skeletor`, fix it before doing anything else:

```bash
git remote set-url origin https://github.com/YOU/your-project.git
```

---

## Step 3 — Run the setup script

```bash
./setup.sh
```

It will prompt for:

| Prompt | Example |
|---|---|
| Project Name | `acme-api` |
| Project Description | `REST API for the Acme widget service` |
| Project Type | `api` (or `web`, `cli`, `lib`) |
| Project Domain | `api.acme.com` |
| Notion Spec Database ID | `abc123def456...` (optional) |
| Notion Wiki Page ID | `789xyz...` (optional) |
| Linear Team ID | `team_abc...` (optional) |

The script:

1. Replaces every `{{PLACEHOLDER}}` in the config files with your answers.
2. Generates `.env.example` with the API keys you'll need.
3. Appends sane defaults to `.gitignore`.
4. Walks the `launcher/` tree if you kept it.

**Verify it worked:**

```bash
grep -r '{{PROJECT_NAME}}' . --exclude-dir=node_modules --exclude-dir=.git
# (should return nothing)
```

---

## Step 4 — Install pre-commit hooks

```bash
./scripts/install-hooks.sh
```

Installs the `pre-commit` framework (via pipx/brew/pip3), wires up the three hook types this repo uses, and warms the cache so your first commit isn't slow. Re-runnable if something goes sideways.

---

## Step 5 — Set GitHub secrets

```bash
gh secret set ANTHROPIC_API_KEY --body "sk-ant-..."
gh secret set LINEAR_API_KEY    --body "lin_api_..."
gh secret set NOTION_API_KEY    --body "secret_..."
gh secret set LINEAR_TEAM_ID    --body "team_..."
gh secret set NOTION_SPEC_DATABASE_ID --body "..."
```

Optional, only if you want them:

```bash
gh secret set OPENAI_API_KEY    --body "sk-..."    # for Codex CLI, if you use it
gh secret set SLACK_WEBHOOK_URL --body "https://hooks.slack.com/..."
```

---

## Step 6 — Apply the label taxonomy

```bash
# This triggers .github/workflows/sync-labels.yml against .github/labels.yml
gh workflow run sync-labels.yml
```

Within a minute, your repo will have the standard `priority:*`, `type:*`, `status:*`, `area:*` taxonomy applied.

---

## Step 7 — Decide on the launcher path

If you're building a static site, keep `launcher/` and read [`launcher/README.md`](./launcher/README.md).

If you're building anything else:

```bash
git rm -r launcher/
git commit -m "chore: remove launcher path (not building a site)"
```

The bootstrap layer is fully independent. Removing the launcher costs you nothing.

---

## Step 8 — First commit & push

```bash
git add -A
git commit -m "chore: initialize project from repo-skeletor"
git push
```

CI will run on push. Expect:

- ✅ `Lint & Type Check` — passes if you haven't written any code yet
- ✅ `Build` — passes (no source = no build failures)
- ✅ `Security Audit` — passes (no deps = nothing to audit)
- ⚠️ `Unit Tests` — will fail until you add a `pnpm test:unit` script and at least one test

That's expected on day zero.

---

## Step 9 — Verify the agent loop

Open an issue in your new repo titled "Test Claude integration". In the issue body:

```
@claude Hello — please confirm you can read this issue and respond.
```

Within ~2 minutes you should see a reply from `claude[bot]`. If nothing happens:

1. Check Settings → Secrets → `ANTHROPIC_API_KEY` is present.
2. Check Settings → Actions → permissions are set to "Read and write".
3. Check the Actions tab for a failed run of `Claude Assistant`.

---

## Step 10 — Wire up Linear/Notion sync (optional)

See [`docs/wiki/Linear-Notion-Sync.md`](./docs/wiki/Linear-Notion-Sync.md) for the full webhook setup. Short version:

1. **Linear → GitHub:** add a webhook in Linear pointing at `https://api.github.com/repos/YOU/your-project/dispatches` with a Bearer PAT and payload `{"event_type": "linear-webhook", "client_payload": {...}}`.
2. **Notion → GitHub:** Notion has no native webhooks; use a thin Cloudflare Worker (template in `docs/wiki/Linear-Notion-Sync.md`) or trigger manually:
   ```bash
   gh workflow run notion-to-linear-sync.yml -f notion_page_id=abc123
   ```

---

## Step 11 — Branch protection

Apply the declarative ruleset in `.github/branch-protection.json`:

```bash
./scripts/apply-branch-protection.sh
```

The script resolves your repo from `git remote`, reads the JSON, and PUTs it to the GitHub API. Re-runnable any time you edit the rules — GitHub replaces the ruleset atomically.

If `gh` is unauthenticated, run `gh auth login` first. If you'd rather click through the UI, every rule in the JSON maps 1:1 to a checkbox under Settings → Branches → Add rule for `main`.

---

## You're done

Three sanity checks before you call it:

```bash
git remote -v                              # not clduab11/repo-skeletor
grep -r '{{PROJECT_NAME}}' . | grep -v node_modules | grep -v .git  # empty
gh secret list                             # shows your keys
```

If all three pass, you're shipping.
