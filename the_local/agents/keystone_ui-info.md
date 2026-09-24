---
name: keystone_ui-info
description: Use to learn what Keystone UI offers — what the component system covers, its layout, color and theme model, and the vocabulary the install and develop locals assume.
tools: Read
scope: UI — pages, forms, tables, navigation, dashboards
---

This local explains Keystone UI and sends you to the local that does the work.
It changes nothing and gives no steps.

## What Keystone UI is

Keystone UI is a Rails engine gem that supplies a host app's visual layer as a
library of view helpers built on ViewComponent. Screens are built from named
pieces — page shells, sections, panels, grids, form fields, data tables,
navigation bars, cards, stat tiles, charts, funnels, goal buckets, pipelines,
banners — instead of hand-written ERB and Tailwind. Every class the UI renders
lives inside the gem, in frozen constants, so the look is defined in one place.

Reach for it whenever you build or change a screen in an app that has it
installed. It exists to stop UI drift: two pages built from the same helpers
cannot disagree about spacing, color or dark-mode treatment, and a change to a
component updates every page that uses it. It is mobile-first — components ship
separate mobile and desktop treatments (a bottom tab bar and mobile header on
small screens, a full navigation bar from the `lg:` breakpoint up), because
these apps are often viewed in a native webview.

## Interface

This local declares no commands. The two working surfaces belong elsewhere:

- **Getting the gem into a host app** — adding it, wiring Tailwind, Stimulus and
  the theme attributes on the layout, setting the palette → **`keystone_ui-install`**.
- **Building UI with it** — which helper renders what, what keywords it takes,
  how helpers nest → **`keystone_ui-develop`**.

## How to use it

One decision: is Keystone UI already set up in the app?

- No, or the setup is out of date → **`keystone_ui-install`**.
- Yes, and you have a screen to build or edit → **`keystone_ui-develop`**. Do not
  hand-write ERB or Tailwind for UI it covers.

Questions about which piece fits a scenario also go to the develop local, which
holds the catalog.

## Conventions

- **Helpers, not classes.** Every piece of UI is a view helper prefixed `ui_`,
  called from ERB. The one layout helper that is not prefixed `ui_` writes the
  theme onto the page's `html` tag, and it belongs to the install local. Components live under the `Keystone::Ui` namespace, but a
  host app does not name a component class directly. The one exception is the
  table column value object, which is passed as an argument and renders nothing.
- **Containers take blocks, leaves take keywords.** Helpers that wrap content
  (page shells, sections, panels, grids, forms, tables) yield a block. Helpers
  that render one thing (a button, a badge, a field, a stat, a bucket) are
  configured entirely by keyword arguments. The navigation bar exposes named
  slots instead of a single block.
- **Options are symbols, and each component accepts its own set.** Appearance is
  chosen by name — `variant:`, `size:`, `type:`, `padding:`, `spacing:`,
  `max_width:`, `radius:` — on a size scale (`:sm` … `:xl`) or a short list of
  named choices. A button's `variant:` and a badge's `variant:` accept
  different symbols, and the develop local carries the real values. Most
  components raise on a symbol they do not know, so a wrong guess fails at
  render time.
- **Semantic color, not literal color.** The themed hue is `accent-*` and the
  themed neutral family is `surface-*`, both CSS custom properties whose
  defaults (blue and zinc) come from the keystone_ui-styles gem. Retheming an
  app changes those values, not the components. Some components still use
  Tailwind's stock `gray-*` and `zinc-*` neutrals, or fixed status colors such
  as green and amber, directly. Changing the defaults belongs to the install
  local.
- **Light, dark, system and custom themes.** Every component has dark-mode
  styling. The theme is chosen in this order: the user's choice stored in a
  cookie, then a mode another gem supplies, then light. System leaves the page
  to follow the operating system. Custom marks the page for a palette another
  gem defines. The theme toggle does not offer it, so a page reaches it when
  another gem supplies it. Marking the layout with the theme is set up through
  the install local, and placing the toggle on a screen goes through the develop
  local.
- **Tailwind classes are static strings.** Class names are never interpolated,
  so Tailwind's scanner can find them. Widths and heights that depend on data,
  such as a progress bar or a bucket's fill, are set with an inline style
  instead. The host needs tailwindcss-rails v4+, and the engine tells Tailwind
  at boot where the component files are.
- **Interactivity is Stimulus.** Dropdowns, modals, dismissible alerts, file
  uploads, the color picker, the multi-select, tab switchers, accordions, the
  swipe deck, column pickers, stat card info panels, line charts, clipboard copy
  and the theme toggle ship with the gem as Stimulus controllers registered once
  at install. A host writes no JavaScript to use them. Components that post
  somewhere, such as the column picker and the pipeline, post to endpoints the
  host app owns.
- Ruby >= 3.2. ViewComponent >= 2.0 and < 5.
