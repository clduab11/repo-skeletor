# Skeletor — Brand Guide v0.1

A working brand for the template itself, and a worked example of the format the token extractor parses. **Edit this file, run `npm run build`, and `src/styles/tokens.css` regenerates from your changes.** That's the whole feedback loop.

If you fork Skeletor for a real project, replace this file's contents with your own brand work. Keep the section structure (`### Core palette`, `### Neutral tonal scale (...)`, `### Signal tonal scale`, `### Semantic states (...)`) — the extractor scans for those headings.

---

## 1 · Premise

Skeletor is the bones of a static site. Astro 5 SSG, dual-target deploy (Vercel preview + arbitrary static host for production), brand-token pipeline, grep gate, accessibility floor. Bring your brand; the scaffold gets out of the way.

The brand applied below to Skeletor's own demo pages exists for one reason: the patterns work end-to-end out of the box. Fork it, swap tokens, swap copy, ship.

## 2 · Mark

A single typographic mark — capital `S` set in the serif display face inside a square frame. The square is the scaffold; the letter is the brand. When you fork, change the letter and recolor the frame and you have a credible mark in five minutes.

The lockups in `/public/brand/` are SVGs you can edit with any vector tool. They use `currentColor` so they inherit ink from the surface they sit on.

## 3 · Type scale (modular, 1.25 ratio)

```
--fs-display    3.815rem
--fs-h1         3.052rem
--fs-h2         2.441rem
--fs-h3         1.953rem
--fs-h4         1.563rem
--fs-h5         1.250rem
--fs-body-lg    1.125rem
--fs-body       1.000rem
--fs-small      0.875rem
--fs-mono       0.938rem
--fs-caption    0.750rem
```

Type families: Source Serif 4 (display + headings), Inter (body + UI), JetBrains Mono (code + technical). All self-hosted via `@fontsource-variable` packages — no Google Fonts, no FOUT.

## 4 · Color

### Core palette

```
--ink       Charcoal          #14181A     primary text, dark surfaces, mark on light
--paper     Bone              #F1EEE8     primary light surface, warm-neutral
--steel     Slate             #4A5159     secondary text, borders, muted surfaces
--signal    Sage              #4A6B4A     single accent — links, CTAs, emphasis
```

Single-accent rule: one signal color, one place to put emphasis. Adding a fifth hue is the most common way to make a static site look like a deck template.

### Neutral tonal scale (derived from Charcoal → Bone, warm-shifted)

```
--n-950   #08090A           page background (dark mode)
--n-900   #14181A   (= ink)
--n-800   #1E2326
--n-700   #2D3338
--n-600   #4A5159   (= steel)
--n-500   #6E7780
--n-400   #939BA3
--n-300   #B6BDC4
--n-200   #D2D8DD
--n-100   #E0E2E0
--n-50    #F1EEE8   (= paper)
--n-0     #FFFFFF           reserved for overlays on dark surfaces only
```

### Signal tonal scale

```
--signal-950   #1A2A1A
--signal-900   #243824
--signal-700   #4A6B4A   (= signal, default)
--signal-500   #6B8A6B
--signal-300   #9DB59D
--signal-100   #D5E0D5
--signal-50    #E8EFE8
```

### Semantic states (UI only, never decoration)

```
--ok        Muted teal       #2A6B5E     success, valid, shipped
--warn      Muted brick      #8B3A3A     error, invalid, at-risk
```

### Contrast floors (WCAG 2.1 AA minimum)

- Body text on Bone: Charcoal at 4.5:1 or better — `#14181A` on `#F1EEE8` = 14.8:1 ✓ AAA
- Body text on Charcoal: Bone at 4.5:1 or better — `#F1EEE8` on `#14181A` = 14.8:1 ✓ AAA
- Steel on Bone for secondary text: `#4A5159` on `#F1EEE8` = 7.2:1 ✓ AAA
- Sage on Bone for links: `#4A6B4A` on `#F1EEE8` = 5.3:1 ✓ AA

## 5 · Layout dialects

Three opinionated grid recipes the scaffold ships with. Pages slot into one. Don't mix.

### Dense — data-forward
12-column grid, 1200px max width, tight gutters. For shipped-work cards, capability grids, technical metadata. Used by `/dense`.

### Editorial — prose-forward
8-column asymmetric grid, 960px max width with optional 1280px bleed for figures. Drop cap on first paragraph of long-form. Used by `/editorial`.

### Sparse — single-thesis
6-column grid, 840px max width, generous vertical rhythm. For manifestos, single essays, coming-soon pages. The whitespace is the design. Used by `/sparse`.

## 6 · Voice (brief)

Direct. Technical-practical. Lead with the outcome, support with evidence, close with a next step. Banned words: revolutionize, transform, unlock, leverage, seamless, cutting-edge, empower, journey, AI-powered, game-changer. The grep gate enforces these as soft warnings on the build output.

## 7 · Quality bar

Every page passes:

1. **Timeless** — would this look right 20 years ago AND 20 years from now?
2. **No cliché imagery** — no abstract networks, no glowing brains, no diverse-team-stock-photo
3. **Token-clean** — all color and type values come from `tokens.css`, not hand-coded hex
4. **Degrades gracefully** — readable without CSS, navigable without JS, all images have alt text
5. **Sized right** — CSS <50KB, JS <100KB per route, fonts subset
6. **Audience-coherent** — a single visitor type can read the page without feeling pitched to the wrong one
