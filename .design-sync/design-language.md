# Hestia design language

Hestia is a household-management app (budget, tasks, shopping, calendar, contacts, baby
profiles…). **All UI copy is French**: sentence case, `« … »` for quotes, amounts as `1 284,90 €`.
The UI examples quoted in this document are therefore in French. The look is warm and grounded:
terracotta brand, warm-tinted neutrals instead of gray, color reserved for status and per-module
accents. This is the "Terre cuite" (terracotta) direction, see below.

## The "Terre cuite" direction: an intentional departure from upstream

The design system was forked from `Create-and-Care/hestia` (`main`): indigo palette, neutral gray,
`text-sm` density. On 2026-07-31 the direction deliberately moved to a warmer terracotta identity.
**A future sync with upstream must re-apply this direction, not go back to indigo.**

| | Upstream (`main`) | Hestia (Terre cuite) |
| --- | --- | --- |
| Brand | indigo `#444CE7` | clay-600 `#A85030` |
| Neutrals | cool gray (`gray-*`) | warm tint derived from `#3A2A22` |
| Destructive | `red-*` (hue ≈ 3°, too close to clay) | `crimson-*` (hue ≈ 348°, cooler) |
| Density | `text-sm`-first (14px body) | `text-base`-first (16px body) |
| Radii | `md` 8px / `lg` 10px | `sm` 8 / `md` 10 / `lg` 14 / `2xl` 20 |
| Controls | h-8/9/10 (32/36/40) | `--control-h-{sm,default,lg}` 36/40/44 |
| Module accents | none upstream | 12 `--module-*` tokens, one per household domain |
| Cool counterpoint | generic blue (`--link`, `--info`) | `pine-*`, a desaturated blue-green (2026-08-12) |
| Editorial accent | none upstream | Instrument Serif via `--font-display` (2026-08-12) |
| Components | none | 4 additions: `ModuleMedallion`, `GreetingHeader`, `CelebrationMoment`, `HouseholdHeader` |

The raw upstream scales (`gray-*`, `red-*`, `indigo-*`, etc.) stay intact for data viz. Only the
**semantic** tokens (brand, neutrals, destructive, cool counterpoint) changed source.

## The four rules

> **Hestia looks like a well-kept home, not a dashboard.**

That is the direction statement: it settles the cases nothing below covers. Reference materials:
ivory paper (the surfaces), matte unglazed terracotta (the brand), unbleached linen (the warm
neutrals). Their photos live on `/design-system/materials`, and nowhere in the product.

1. **Pine is the cool counterpoint, never a second brand.** It takes what informs without asking
   for action (links, `--info`, gauges, neutral data series). Terracotta keeps what activates.
   Pine never appears in module accents, on a status badge or as a button fill: wanting to put
   it there signals a missing token, not a color.
2. **The accent never fills a button.** Amber marks: a dot, a tick in a gauge. An amber button is
   either a primary in disguise or a mislabelled warning.
3. **A 1px hairline rather than a gap.** Inside a card, a `border-subdued` rule builds hierarchy
   better than a 20px `gap`. Gaps separate cards; hairlines separate what they contain.
4. **One elevation level at a time.** A card sits on the page, a menu floats above it: never a
   shadowed card inside a shadowed card. What lives inside a raised surface is separated by a
   hairline (rule 3), not by a second shadow.

## Surfaces & color roles

Style with **semantic utility classes** — they swap automatically in dark mode. Never hardcode
grays for chrome, and never use `dark:` variants (theming is class-based via tokens).

| Role | Classes |
| --- | --- |
| Page background | `bg-surface` (body default), hover rows `hover:bg-surface-hover` |
| Card / panel | `bg-container` + `border border-primary rounded-lg`, or `shadow-border-xs` |
| Inset well (code, tab track, skeleton) | `bg-surface-inset`, `bg-container-inset` |
| Text hierarchy | `text-primary` → `text-secondary` → `text-subdued`; on dark fills `text-inverse` |
| Links | `text-link`, buttons variant `link` add `hover:underline underline-offset-4` |
| Gauges | `bg-gauge` (pine, rule 1): `Progress` and any bar that measures without asking for action |
| Charts | A single series (a pH day after day, a weight curve) is neutral: `Ui::ChartComponent` draws it in `--gauge`. The rotating module palette is opt-in, `categorical: true`, for bars that are categories (the Budget's expense breakdown) |
| Supporting figure | `text-support-figure` (pine-600 / pine-300): the line that situates a hero amount, « sur 1 600,00 € prévus · 12 jours restants ». Only through `Ui::StatComponent`'s `support` slot, never clickable: pine text you can click is a link (`text-link`) |
| Status | `text-success` / `text-warning` / `text-destructive` / `text-info` / `text-accent`; tinted fills `bg-success/10`, `bg-warning/10`, `bg-destructive/10`, `bg-accent/10` |
| Borders | `border-primary` (default), `border-secondary`/`border-subdued` (quieter), `border-divider` (hairlines) |
| Focus | `focus-visible:ring-focus` (2px neutral ring) |
| Buttons | `bg-button-primary`/`-secondary`/`-destructive` + `hover:bg-button-*-hover`, ghost/outline hovers `bg-button-ghost-hover`/`bg-button-outline-hover` (full recipes in `guidelines/components/formulaires-saisie.md`) |

Raw palette (`bg-gray-100`, `text-red-700`, plus the additions `clay-*`, `crimson-*` and `pine-*`,
25–900 scales in `tokens/tokens.md`) is for data viz and illustrations only — chrome always uses
the semantic roles above. `pine-*` in particular is never hand-painted: a link is `text-link` and
an info tint is `bg-info/10`, so the counterpoint stays in one place (rule 1).

## Contrast contract

`--success` / `--warning` / `--destructive` / `--info` / `--accent` are tuned as **fills** (dots,
bars, borders) — at 13–15px on a 10% tint several land under 4.5:1. The rule:

> **The fill uses `--X`, the text on it uses `--X-text`.**

`--success-text` / `--warning-text` / `--destructive-text` / `--info-text` / `--accent-text` are
the separately-tuned, contrast-safe counterparts — that's what `text-success` etc. actually
resolve to (mapped `!important` in `application.tailwind.css` so Tailwind's auto-generated
`text-*` utilities can't win by source order). `Badge`, `Alert`, and `Field`'s error line all use
these, never the base `--X` token, for their text color.

Same logic for links: `--link` is `pine-700`, not `pine-600` — 8.4:1 on `--surface` against 6.3:1,
and `pine-600` is reserved as the `--info` fill. Dark mode mirrors it with `pine-300` (9.1:1). A
global `a` / `a:hover` rule lives in `@layer base` — an unstyled link never falls back to the
browser default blue.

## Layout on a phone

- **A button never wraps its label** (`whitespace-nowrap` in `Button`/`ButtonTo`); the row around it
  wraps instead. Every page header (`<header class="flex ...">`) and every group of actions is
  `flex-wrap`.
- **A list row keeps its text readable**: the text block is `grow basis-40` (`Ui::ItemComponent`) or
  `grow basis-48` (hand-built rows), never `flex-1` alone, whose basis of 0 let the action icons
  crush the name to one word a line. The actions wrap under the text, pushed right by `ml-auto`.
- **A breadcrumb crumb moves whole** to the next line, never breaking inside its label.
- **A tab strip scrolls** (`Tabs`), its labels never wrap.

## Lists and statuses (decided 2026-09-19)

- **One outlined list, hairlines between rows** (rule 3): the container is
  `flex flex-col divide-y divide-primary rounded-lg border border-primary`
  (`Ui::ViewToggleComponent.container_classes("list")`), a row brings padding only. Never a stack of
  one card per row; the grid view is the one place each row is its own card. Inside a card
  (a cellar, a task board column) the rows take the hairlines without a second outline (rule 4).
- **A status is text, never a fill**: an overdue routine, plant task or task carries the
  `destructive` Badge « En retard »; the row itself stays neutral. The same holds for section titles
  (`.section-title` is always `text-primary`).
- **Secondary actions go behind « … »** (`Ui::DropdownMenuComponent` with a block of `button_to`s
  taking `DropdownMenuComponent.item_options`): a card keeps two or three icon buttons in reach.
  Confirmations go through the global dialog (`data-turbo-confirm`), with
  `data-turbo-confirm-label` / `data-turbo-confirm-variant="default"` when the action is not a
  destruction.
- **A filter strip is `Ui::FilterChipComponent`**, never a `Badge` with a link dropped in it.
- **Titles align left**, on every page; only an object shown for itself (a loyalty card's code)
  is centred inside its own card.
- **A choice between a few options is shown whole**: the theme in settings is the three-way
  `ThemeToggle variant: :segmented`, not a lone cycling icon.

## Shape, elevation, spacing

- Radius: `--radius-sm` 8px (chips, checkboxes), `--radius-md` 10px (buttons, inputs, menu
  items), `--radius-lg` 14px (cards, panels, popovers, dialogs), `--radius-2xl` 20px (bubbles),
  `--radius-full` (pills, avatars, icon dots) — softened/expanded vs. upstream's 8/10.
- Elevation: `shadow-border-{xs,sm,md,lg,xl}` — shadow plus a 1px hairline. Cards sit flat
  (`border-primary` or `shadow-border-xs`); menus/popovers float with `shadow-border-md`;
  dialogs/sheets with `shadow-border-lg` or `-xl`. Plain `shadow-*` exists but the paired
  `shadow-border-*` is the house style.
- Spacing rhythm: `gap-2` icon↔label, `gap-1.5` compact; `p-4`/`p-6` card padding; `gap-4`/
  `gap-6` between sections; `space-y-1` menu lists. Controls are `--control-h-sm` 36px /
  `--control-h-default` 40px / `--control-h-lg` 44px — the single source of truth `Button`,
  `Input`, `Select`, `Textarea`, and `InputOtp` all read from (`InputOtp` is 40 wide × 44 tall).
  The 4px spacing step itself is unchanged from upstream.

## Typography

`font-sans` = Geist with system fallback (no webfont ships — system stack in practice);
`font-mono` = IBM Plex Mono stack for code, kbd, amounts in tables, and the `.eyebrow` (the date
above the greeting); `--font-display` = Instrument Serif, see "Household warmth" below. Weights:
400/500/600 (`font-normal`/`font-medium`/`font-semibold`) — nothing heavier, and **400 only** on the serif, which ships no other weight: anything bolder is a
synthetic bold on screen. Scale enlarged from text-sm-first to text-base-first (body 16px, was 14px):
`text-xs` 13 · `text-sm` 15 · `text-base` 16 · `text-lg` 20 · `text-xl` 22 · `text-2xl` 26 ·
`text-3xl` 32 · `text-4xl` 40.

| Level | Classes |
| --- | --- |
| h1 | `.h1` (40px, line-height 1.15, letter-spacing -0.02em, semibold) |
| h2 | `.h2` (32px, line-height 1.2) |
| h3 | `.h3` (26px, line-height 1.25) |
| h4 / page section | `.h4` (22px, line-height 1.3) |
| Lead | `text-lg text-secondary` (20px) |
| Body | `.body-text text-primary` (16px / line-height 1.6) |
| Large | `text-lg font-semibold text-primary` (20px) |
| Small / Muted | `text-sm` (15px) — `font-medium leading-none` for small, `text-secondary` for muted |
| Code | `rounded-[6px] bg-surface-inset px-1.5 py-0.5 font-mono text-sm text-primary` |

`Ui::TypographyComponent` is the canonical implementation of this scale — read it rather than
hand-rolling heading classes.

## Icons

Lucide, vendored under `app/assets/icons/lucide`. Two rendering paths, pick by whether the icon
needs a color it can't inherit from surrounding text:

- **`lucide_icon(name)`** — inlines the SVG with `stroke="currentColor"`, default
  `class="size-4"`. Sizes and colors like text. The default for icons sitting next to a label.
- **`lucide_icon_mask(name)`** — paints the icon via CSS `mask` (`background-color: currentColor`
  clipped to the glyph shape) instead of inlining the SVG. Required whenever the icon's color
  must come from something other than inherited text color — e.g. `ModuleMedallionComponent`,
  where the glyph is `text-module-*` but the wrapping `<span>` has no text content for an inline
  SVG's `stroke="currentColor"` to key off visually the same way. **Never render a colored icon
  as `<img src=...>`** — an `<img>` can't inherit `currentColor` at all and renders black
  regardless of the module color, which defeats the point of a module accent.

Stick to the vendored set: arrow-left, arrow-right, baby, bell, book-open, cake, calendar-plus,
calendar, car, carrot, check, chef-hat, clock, credit-card, droplet, dumbbell, euro, file-text,
gift, grip-vertical, handshake, heart-pulse, house, info, layout-dashboard, layout-grid, link,
list, list-checks, list-filter, luggage, mail, map, map-pin, message-circle, mic, milk, minus,
notebook-pen, package, paperclip, paw-print, pencil, phone, pill, plus, puzzle, recycle,
refresh-cw, refrigerator, repeat, scale, search, settings, shopping-cart, smartphone, sofa,
sprout, square-check, star, sun, syringe, trash-2, trees, trending-up, triangle-alert, users,
users-round, utensils, waves, wine, wrench, x.

## Dark mode

Add `class="dark"` on `<html>`: every semantic token swaps (warm near-black `--background`
`#14100E`, never pure `#000`; `clay-300` brand; warm off-white primary text). The `dark:` variant
is bound to that class too (`@custom-variant dark` in `application.tailwind.css`), not to the OS
setting: it used to follow `prefers-color-scheme`, so a Mac in dark mode painted `Swatch`'s dark
shades on a light page. A design built
only from semantic classes needs zero extra work to support it — **never write a `dark:`
variant**; if you find yourself reaching for one, the right fix is a new semantic token, not an
inline override. That's the test of doing it right.

## Motion

Floating panels animate with `animate-in fade-in-0 zoom-in-95` on open (`animate-out
fade-out-0 zoom-out-95` on close), sheets/drawers with `slide-in-from-{top,bottom,left,right}`,
accordions with `animate-accordion-down/up`. Durations 150–300ms (`duration-200` etc.). This is
the only motion in the system — see "Household warmth" below for what deliberately gets none.

## Household warmth ("Chaleur du foyer")

Four components exist with no upstream equivalent — assumed additions, not gaps to fill on the
next sync:

- **`ModuleMedallionComponent`** — a Lucide glyph in a circle tinted 12% by module color, via
  `lucide_icon_mask` (see Icons above). Sizes 32/44/64.
- **`GreetingHeaderComponent`** — hour-of-day salutation in the `.greeting` class (44px serif,
  weight 400, line-height 1.05, letter-spacing -0.01em), plus one line of real context. Slots:
  Bonne nuit (0–5h) · Bonjour (5–11h) · Bon appétit (11–14h) · Bon après-midi (14–18h) · Bonsoir
  (18–22h) · Bonne soirée (22–24h). `hour`/`greeting` props override.
- **`CelebrationMomentComponent`** — a band tinted 10%, three kinds: `birthday` (gifts/cake),
  `streak` (courses/sprout), `milestone` (calendar/star). Title in the serif at 28px/400 — 28
  rather than the scale's 26 because the serif has a smaller x-height than Caveat had.
- **`HouseholdHeaderComponent`** — household photo, name, members. No photo → a warm invitation
  to add one, never a gray square.

**Restraint is the point.** No emoji, no exclamation points, no confetti, no animation on any of
the four — the editorial serif accent alone carries the warmth.

The serif appears in exactly **three** components: `GreetingHeader`, `CelebrationMoment`, and the
`Empty` title (22px/400). Outside them it is granted in two places only: the hero amount of
`Ui::StatComponent` (`.hero-amount`, 34px, e.g. the four Budget cards) and `.section-title`
(24px, always `text-primary`, dashboard and Today (« Aujourd'hui ») section headings; the status of what is
under it belongs to the rows' badges, not to the title's color). Never a label, never a table
cell, never under 20px, and never more than one line in a data view. Grep for
`--font-display`/`.greeting`/`.section-title`/`.hero-amount` before granting it anywhere else.

`GreetingHeader` also carries today's date above the greeting, as an `.eyebrow`: IBM Plex Mono,
13px, `text-secondary`, capitalised (« Samedi 19 septembre »). It situates the greeting and never
competes with it.

## Warm editorial tone

- Greet by first name, with no comma: « Bonjour Anthony », not « Bonjour, Anthony ».
- One line of real context under the greeting (e.g. the number of tasks due today), never a
  generic welcome sentence.
- Empty states read as encouragement, not as an error: « Ajoutez une photo du foyer », not
  « Aucune photo ». No exclamation marks.

## Intentional additions

What has no upstream equivalent, to preserve during a future sync:

- The `clay-*` (brand), `crimson-*` (destructive) and `pine-*` (cool counterpoint) scales. See
  "The Terre cuite direction" and "The four rules" above.
- `--font-display` (Instrument Serif) and the `.greeting`, `.section-title` and `.hero-amount`
  classes, plus `.eyebrow` in IBM Plex Mono. The deprecated `--font-hand` alias was removed on
  2026-09-19, once nothing called it.
- The `--gauge` token (pine-600 in light, pine-400 in dark) for gauges and single-series charts,
  and `--support-figure` (pine-600 / pine-300) for the supporting figure of `Ui::StatComponent`.
- The `/design-system/materials` page (material boards, photos in `app/assets/images/materials/`).
- The `tint` prop on `Avatar`/`AvatarGroup`: a module key or a raw CSS color, falling back to a
  hash over the pool of 12 module accents.
- The 4 "household warmth" components: `ModuleMedallion`, `GreetingHeader`, `CelebrationMoment`,
  `HouseholdHeader`.
- `Ui::StatComponent` and `Ui::FilterChipComponent`, and the `:segmented` variant of
  `Ui::ThemeToggleComponent`.
- The empty-state illustration system (`Empty#illustration`, full brief on
  `/design-system/illustrations`).
