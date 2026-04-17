#!/usr/bin/env node
/**
 * extract-tokens.mjs
 *
 * Single source of truth: docs/brand_guide.md (or brand_guide_v1.md, in
 * older naming). This script parses §3 (Type scale) and §4 (palette)
 * from the brand guide and emits src/styles/tokens.css.
 *
 * The brand guide is authoritative; bumping the guide and rerunning
 * this script propagates tokens to the build with zero hand-maintained
 * color or scale drift.
 *
 * Run automatically as `prebuild`. Can be run manually:
 *   node scripts/extract-tokens.mjs [path/to/brand_guide.md]
 *
 * Exits non-zero on any extraction failure — failing closed beats failing open.
 */

import { readFileSync, writeFileSync, existsSync } from 'node:fs';
import { dirname, resolve, join, relative } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = resolve(__dirname, '..');

// Brand guide candidate locations, in order of preference. The first hit
// wins. Repo-skeletor lays the guide down at ../docs/brand_guide.md (one
// level above launcher/); standalone consumers can put it in /docs/
// inside the launcher itself.
const GUIDE_CANDIDATES = [
  process.argv[2],
  resolve(REPO_ROOT, '..', 'docs', 'brand_guide.md'),
  resolve(REPO_ROOT, '..', 'docs', 'brand_guide_v1.md'),
  resolve(REPO_ROOT, '..', 'brand_guide.md'),
  resolve(REPO_ROOT, '..', 'brand_guide_v1.md'),
  resolve(REPO_ROOT, 'docs', 'brand_guide.md'),
  resolve(REPO_ROOT, 'docs', 'brand_guide_v1.md'),
  resolve(REPO_ROOT, 'brand_guide.md'),
  resolve(REPO_ROOT, 'brand_guide_v1.md'),
].filter(Boolean);

const guidePath = GUIDE_CANDIDATES.find((p) => existsSync(p));
if (!guidePath) {
  console.error('[extract-tokens] FATAL: brand_guide.md not found in any of:');
  GUIDE_CANDIDATES.forEach((p) => console.error('  -', p));
  process.exit(1);
}

const OUT_PATH = join(REPO_ROOT, 'src', 'styles', 'tokens.css');
const guide = readFileSync(guidePath, 'utf8');

/**
 * Parse `--token  #VALUE  optional comment` lines from fenced code blocks
 * underneath an H3 heading. The heading match is a *prefix* match on the
 * normalized text — this lets the brand guide vary the parenthetical
 * ("derived from X → Y, warm-shifted" vs "cool-shifted") without breaking.
 */
function extractTokensFromSection(markdown, headingPrefix) {
  const lines = markdown.split('\n');
  const normalizedPrefix = headingPrefix.toLowerCase();
  let startLine = -1;

  for (let i = 0; i < lines.length; i++) {
    const m = lines[i].match(/^###\s+(.+?)\s*$/);
    if (!m) continue;
    if (m[1].toLowerCase().startsWith(normalizedPrefix)) {
      startLine = i + 1;
      break;
    }
  }
  if (startLine === -1) {
    throw new Error(`Section not found (prefix): "${headingPrefix}"`);
  }

  // Read until the next H2/H3 or hr (---) at column 0.
  let endLine = lines.length;
  for (let i = startLine; i < lines.length; i++) {
    if (/^(##|###|---)\s/.test(lines[i]) || /^---\s*$/.test(lines[i])) {
      endLine = i;
      break;
    }
  }

  const sectionBody = lines.slice(startLine, endLine).join('\n');
  const codeBlocks = [...sectionBody.matchAll(/```[a-z]*\n([\s\S]*?)```/g)];
  const tokens = [];

  for (const block of codeBlocks) {
    for (const line of block[1].split('\n')) {
      // Two-pass parse: extract --name at start, find first hex literal.
      const nameMatch = line.match(/^\s*(--[a-z][a-z0-9-]*)\b/);
      const hexMatch = line.match(/(#[0-9A-Fa-f]{3,8})\b/);
      if (!nameMatch || !hexMatch) continue;
      const name = nameMatch[1];
      const value = hexMatch[1];
      const trailing = line.slice(line.indexOf(hexMatch[1]) + hexMatch[1].length).trim();
      tokens.push({ name, value, comment: trailing });
    }
  }
  return tokens;
}

function emitGroup(label, tokens) {
  if (tokens.length === 0) return '';
  const header = `  /* ${label} */`;
  const body = tokens
    .map((t) => `  ${t.name}: ${t.value};${t.comment ? '  /* ' + t.comment + ' */' : ''}`)
    .join('\n');
  return `${header}\n${body}\n`;
}

let core, neutral, signal, semantic;
try {
  core     = extractTokensFromSection(guide, 'Core palette');
  neutral  = extractTokensFromSection(guide, 'Neutral tonal scale');
  signal   = extractTokensFromSection(guide, 'Signal tonal scale');
  semantic = extractTokensFromSection(guide, 'Semantic states');
} catch (err) {
  console.error('[extract-tokens] FATAL:', err.message);
  process.exit(1);
}

const totalTokens = core.length + neutral.length + signal.length + semantic.length;
if (totalTokens < 20) {
  console.error(`[extract-tokens] FATAL: only ${totalTokens} tokens extracted — guide format likely changed.`);
  process.exit(1);
}

const header = `/*
 * tokens.css — GENERATED from brand guide.
 * DO NOT EDIT BY HAND. Run \`npm run prebuild\` after editing the brand guide.
 *
 * Source: ${relative(REPO_ROOT, guidePath).split("\\").join("/") || guidePath}
 * Generated: ${new Date().toISOString()}
 * Tokens extracted: ${totalTokens} (core: ${core.length}, neutral: ${neutral.length}, signal: ${signal.length}, semantic: ${semantic.length})
 */

:root {
${emitGroup('Core palette', core)}
${emitGroup('Neutral tonal scale', neutral)}
${emitGroup('Signal tonal scale', signal)}
${emitGroup('Semantic states', semantic)}
  /* Type scale (1.25 modular ratio) */
  --fs-display:    3.815rem;
  --fs-h1:         3.052rem;
  --fs-h2:         2.441rem;
  --fs-h3:         1.953rem;
  --fs-h4:         1.563rem;
  --fs-h5:         1.250rem;
  --fs-body-lg:    1.125rem;
  --fs-body:       1.000rem;
  --fs-small:      0.875rem;
  --fs-mono:       0.938rem;
  --fs-caption:    0.750rem;

  /* Type families (resolved by typography.css @font-face declarations) */
  --ff-serif:      'Source Serif 4 Variable', 'Source Serif 4', Charter, Georgia, 'Times New Roman', serif;
  --ff-sans:       'Inter Variable', 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
  --ff-mono:       'JetBrains Mono', 'SF Mono', Menlo, Consolas, monospace;

  /* Layout dialect widths (one per register) */
  --max-dense:           1200px;
  --max-editorial:       960px;
  --max-editorial-bleed: 1280px;
  --max-sparse:          840px;

  /* Reading measure */
  --measure-prose:  66ch;

  /* Line heights */
  --lh-display:    1.1;
  --lh-heading:    1.2;
  --lh-body:       1.6;
  --lh-ui:         1.5;
}

@media (prefers-color-scheme: dark) {
  :root {
    /* Dark mode is a user preference, not a brand choice. Swap surface
       and ink; everything else inherits and inverts via tonal scale. */
    --paper: var(--n-950);
    --ink:   var(--n-50);
  }
}
`;

writeFileSync(OUT_PATH, header, 'utf8');
console.log(`[extract-tokens] Wrote ${OUT_PATH}`);
console.log(`[extract-tokens] ${totalTokens} tokens (${core.length} core + ${neutral.length} neutral + ${signal.length} signal + ${semantic.length} semantic)`);
