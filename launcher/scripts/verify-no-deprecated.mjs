#!/usr/bin/env node
/**
 * verify-no-deprecated.mjs
 *
 * Pre-deploy grep gate. Walks the build output and fails the build if any
 * "deprecated" string from the project's deny-list appears in any shipped
 * file. Each consumer configures their own deny-list in verify.config.json
 * at the launcher root — see the shipped default for the expected shape.
 *
 * Usage: node scripts/verify-no-deprecated.mjs [dir] [--config path]
 *   dir defaults to ./dist
 *   --config defaults to ./verify.config.json (then verify.config.default.json)
 *
 * Exit codes:
 *   0 — pass (any number of soft warnings)
 *   1 — fatal hit, or scan/config error
 */

import { readdirSync, readFileSync, statSync, existsSync } from 'node:fs';
import { join, extname, relative, resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = resolve(__dirname, '..');

// Argument parsing — first positional is the dir, --config takes the path.
const argv = process.argv.slice(2);
let dirArg, configArg;
for (let i = 0; i < argv.length; i++) {
  if (argv[i] === '--config') { configArg = argv[++i]; continue; }
  if (!dirArg) dirArg = argv[i];
}

const root = resolve(dirArg || 'dist');

const CONFIG_CANDIDATES = [
  configArg,
  resolve(REPO_ROOT, 'verify.config.json'),
  resolve(REPO_ROOT, 'verify.config.default.json'),
].filter(Boolean);

const configPath = CONFIG_CANDIDATES.find((p) => existsSync(p));
if (!configPath) {
  console.error('[verify] FATAL: no verify config found in any of:');
  CONFIG_CANDIDATES.forEach((p) => console.error('  -', p));
  console.error('[verify] Ship verify.config.default.json or supply --config.');
  process.exit(1);
}

let config;
try {
  config = JSON.parse(readFileSync(configPath, 'utf8'));
} catch (err) {
  console.error(`[verify] FATAL: cannot parse ${configPath}: ${err.message}`);
  process.exit(1);
}

if (!Array.isArray(config.forbidden)) {
  console.error(`[verify] FATAL: ${configPath} must export { "forbidden": [...] }`);
  process.exit(1);
}

// Compile each rule. Each entry: { pattern: string, flags?: string, label: string, severity: 'fatal'|'warn' }
const FORBIDDEN = config.forbidden.map((rule, i) => {
  if (!rule.pattern || !rule.label || !rule.severity) {
    console.error(`[verify] FATAL: rule[${i}] missing one of pattern/label/severity`);
    process.exit(1);
  }
  if (rule.severity !== 'fatal' && rule.severity !== 'warn') {
    console.error(`[verify] FATAL: rule[${i}] severity must be "fatal" or "warn"`);
    process.exit(1);
  }
  return {
    pattern: new RegExp(rule.pattern, rule.flags ?? ''),
    label: rule.label,
    severity: rule.severity,
  };
});

const SCANNABLE_EXTS = new Set(
  Array.isArray(config.scannableExtensions)
    ? config.scannableExtensions
    : ['.html', '.css', '.js', '.txt', '.xml', '.svg', '.json', '.md']
);

function walk(dir) {
  const out = [];
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    const st = statSync(full);
    if (st.isDirectory()) {
      out.push(...walk(full));
    } else if (SCANNABLE_EXTS.has(extname(full))) {
      out.push(full);
    }
  }
  return out;
}

let files;
try {
  files = walk(root);
} catch (err) {
  console.error(`[verify] FATAL: cannot scan ${root}: ${err.message}`);
  console.error('[verify] Did you run `npm run build` first?');
  process.exit(1);
}

const fatalHits = [];
const warnHits = [];

for (const file of files) {
  const text = readFileSync(file, 'utf8');
  for (const rule of FORBIDDEN) {
    if (rule.pattern.test(text)) {
      const lines = text.split('\n');
      const matchedLines = lines
        .map((line, i) => ({ line, num: i + 1 }))
        .filter(({ line }) => rule.pattern.test(line));
      const hit = {
        file: relative(process.cwd(), file),
        rule: rule.label,
        lines: matchedLines.map((m) => `${m.num}: ${m.line.trim().slice(0, 120)}`),
      };
      if (rule.severity === 'fatal') fatalHits.push(hit);
      else warnHits.push(hit);
    }
  }
}

if (warnHits.length > 0) {
  console.warn(`\n[verify] WARN: ${warnHits.length} soft-warning hit(s) (non-fatal):`);
  for (const h of warnHits) {
    console.warn(`  ${h.file}  [${h.rule}]`);
    h.lines.slice(0, 3).forEach((l) => console.warn(`    ${l}`));
  }
}

if (fatalHits.length > 0) {
  console.error(`\n[verify] FATAL: ${fatalHits.length} hard-deprecated string(s) found in build output:`);
  for (const h of fatalHits) {
    console.error(`  ${h.file}  [${h.rule}]`);
    h.lines.forEach((l) => console.error(`    ${l}`));
  }
  console.error(`\n[verify] Build cannot ship. Config: ${configPath}`);
  process.exit(1);
}

console.log(`[verify] PASS: ${files.length} files scanned, 0 hard-deprecated strings.${warnHits.length > 0 ? ` (${warnHits.length} soft warnings to review.)` : ''}`);
console.log(`[verify] Config: ${configPath}`);
