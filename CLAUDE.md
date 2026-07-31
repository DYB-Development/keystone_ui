# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Keystone UI is a Rails gem providing reusable UI components built on `view_component`. It provides UI primitives that avoid ERB noise, prevent UI drift, and enable safe mass updates.

## Commands

```bash
bundle install              # Install dependencies
bundle exec rake test       # Run all tests
bundle exec rake test TEST=test/keystone/ui/button_component_test.rb  # Run a single test file
```

No build step or linter is configured.

## Architecture

This is a Rails engine gem structured around ViewComponent. The three-layer architecture is:

1. **Components** (`app/components/keystone/ui/`) — Ruby classes inheriting `ViewComponent::Base` with explicit keyword arguments, paired with `.html.erb` templates. All UI logic lives here.
2. **Helpers** (`app/helpers/keystone_ui_helper.rb`) — Thin render wrappers that delegate to components. Helpers contain no logic or conditionals. Consuming apps use helpers, not component classes directly.

Components use Tailwind CSS utility classes directly. The engine ships a CSS file (`app/assets/tailwind/keystone_ui_engine/engine.css`) with `@source` directives that tell Tailwind where to scan for classes. Host apps require `tailwindcss-rails` v4+.

## Design Principles

- All UI lives in ViewComponents (no partials).
- Components are Ruby objects with explicit keyword arguments.
- Helpers are thin render wrappers with no logic or conditionals.
- Styling uses Tailwind CSS utility classes applied directly in components.

## Testing

Tests use Minitest. The test helper stubs `ViewComponent::Base` so tests run without a full Rails environment. Tests validate component logic (class composition, tag options, normalization) rather than rendered HTML.

## Color System

Components use semantic CSS custom properties (`--color-accent-*`, `--color-surface-*`) via Tailwind classes like `bg-accent-500`, `text-accent-600`, etc. The `theme.css` file in the engine sets default values. Host apps can override these via CSS, or use the `keystone_colors` gem for per-user theming.

## Key Conventions

- Ruby >= 3.1.0 required.
- Components live under the `Keystone::Ui` namespace.
- The DataTableComponent uses Tailwind CSS utility classes with predefined position-based class constants (first/middle/last cell styling). It accepts `items` (AR objects or hashes) and `columns` (simple `{ key: "Label" }` hashes or `Keystone::Ui::Column` objects), resolving cell values automatically. `Column` objects support per-column options: `mobile_hidden: true` (appends `hidden sm:table-cell` classes), `sortable: true` (renders header as clickable sort link), and `hideable: true` (allows hiding via `hidden_columns:`). A block-based API registers links via `table.link(:column_key) { |item| url }` and actions via `table.actions { |item| ... }`. When an actions column is present, position classes shift so the actions column gets LAST styling. Sortable columns accept `sort:`, `sort_direction:`, and `sort_url:` (a lambda) params — headers render as `<a>` links with arrow icons and `data-turbo-action="replace"`. Hidden columns are filtered server-side via the `hidden_columns:` param; only columns marked `hideable: true` can be hidden.
- ColumnPickerComponent renders a "Columns" dropdown with checkboxes for each `hideable` column. It accepts `columns:`, `hidden_columns:`, and `save_url:`. The Stimulus `column-picker` controller handles toggle/close and PATCHes hidden column preferences to `save_url` as JSON, then reloads via `Turbo.visit`.
- GridComponent uses a `COL_CLASSES` frozen hash mapping `{breakpoint => {count => "literal-class"}}` for cols 1-12 across `default`, `sm`, `md`, `lg` breakpoints. All Tailwind classes are complete static strings (never interpolated) so the JIT scanner can detect them. Gap classes use the same pattern via `GAP_CLASSES`, `GAP_X_CLASSES`, and `GAP_Y_CLASSES` constants.
- ButtonComponent conditionally renders `<a>` or `<button>` based on whether `href` is provided.
- NavbarComponent is the top-level navigation bar with slots for `logo`, `desktop_links`, `desktop_right`, `mobile_left`, `mobile_center`, and `mobile_right`. Supports `sticky: true` (default) for fixed positioning. Mobile sections are hidden on `lg:` screens and vice versa.
- NavDropdownComponent renders a dropdown menu within the navbar. Accepts `title`, `area`, and `active` flag. Uses Stimulus `dropdown` controller for toggle behavior.
- NavItemComponent is a single nav link with `label`, `href`, and `active` state.
- BottomNavComponent renders a mobile bottom tab bar, hidden on desktop (`lg:hidden`).
- BottomNavItemComponent is a single bottom nav tab with `label`, `href`, `icon` (SVG string), and `active` state.
- MobileHeaderComponent renders a mobile header with back link, centered title, and optional subtitle. Hidden on `lg:` screens.
- MobileActionsComponent renders an ellipsis dropdown for mobile action menus. Hidden on `lg:` screens. Uses Stimulus `dropdown` controller.
- FormComponent wraps content in a `<form>` tag with `action:`, `method:` (Rails-style `_method` override for patch/put/delete), `multipart:` for file uploads, and `data:` attributes.
- FileUploadComponent renders a styled file input with clickable drop zone, drag-and-drop support, and file name feedback. Accepts `accept:` for file types, `multiple:` for multi-file, and `hint:` text. Uses `file-upload` Stimulus controller and `UPLOAD_ICON` (excluded from safelist via `SKIP_CONSTANTS`).
- FormPageComponent wraps form pages with `title`, `back_url`, and optional `subtitle`. Sets `content_for` signals (`:form_page`, `:form_page_title`, `:form_page_back_url`) so the navbar can render mobile header context.
- ShowPageComponent wraps show pages with `title`, `back_url`, and optional `subtitle`. Sets `content_for` signals (`:show_page`, `:show_page_title`, `:show_page_back_url`, `:show_page_subtitle`).
- SettingsLinkComponent renders a gear icon link for settings navigation.
- ProgressComponent renders a labeled progress bar. `percent` is `value / max * 100` rounded and **clamped at 100**; an optional `label` caption renders above a rounded track. The bar width is applied via inline `style="width: N%"` (not a Tailwind class).
- RadioCardComponent renders a selectable card backed by a real `<input type="radio">` (visually `sr-only`); the selected state is pure CSS via `peer-checked:` styling (no Stimulus). Supports an optional `hint` sub-label and `checked:` pre-selection.
- PipelineComponent renders an interactive staged-flow diagram — a row of `boxes` connected by breakable `links` — for mapping event flows, data pipelines, approval chains, or state machines. The component owns the look and the post-to-endpoint contract; the host supplies data and handles the posts. Each box has a `label`, optional `count` + `accent` (`:amber`/`:emerald`/`:danger`/`:muted`, mapped onto the keystone palette), and an optional `action` that POSTs to a `url` with hidden `params` (rendered via `ui_button`). `links` has one fewer entry than `boxes`; each link's ✓/✗ toggle POSTs to flip its `broken` state. Boxes stack vertically with connectors shown between them on mobile, laying out horizontally on `sm+`. All classes are frozen constants. (Code-snippet boxes, dead-letter offshoots, badge, and title link are deferred follow-ups.)
- FunnelComponent renders a conversion funnel for analytics/stats pages. The top layer spans 100% width; each lower layer's bar width is relative to the **first** step's value (applied via inline `style="width: N%"`). Each layer's label and value sit on a full-width row **above** the bar so they stay legible at any depth on mobile/hotwire-native webviews; transitions between layers show the **step-to-step** conversion percent (`value / previous step's value`). Divide-by-zero safe, no JS. The component is pure — compose a lazy `turbo_frame_tag` per funnel for async stats loading.
- All CSS classes must be in frozen constants (not inline strings) so the safelist generator can extract them. SVG/HTML icon constants (`ELLIPSIS_ICON`, `BACK_ICON`, `CARET_ICON`, `SORT_ASC_ICON`, `SORT_DESC_ICON`, `SORT_NEUTRAL_ICON`, `COLUMNS_ICON`) are excluded from safelist scanning via `SKIP_CONSTANTS`.

<!-- the_local:begin -->
## Delegate to your locals

This project has installed expert subagents. Before doing work yourself,
check whether a local owns it and delegate — never work from memory on
something a local covers:

- resident Claude Code experts — authoring a gem's locals and installing them into a host → the_local-* agents

See each agent's description for specifics.
<!-- the_local:end -->

<!-- the_local:process:begin -->
Read and follow this develop process for all work in this project. It is
also written verbatim to `develop_process_rules.md` — reference that file directly.

# Develop Process

The standard process for writing code across all projects. Default to these rules
unless a project explicitly overrides them.

---

## Diverging from this process

Read this process before starting work and follow it — it is the default for
every session. If a task genuinely calls for breaking one of these rules, do not
silently deviate: **PAUSE and ask for a one-time exception**, naming the rule and
why it should be set aside here. An exception is granted for that instance only —
it needs no doc or notes update — and then you continue. Do not treat a granted
exception as a standing change to the process.

---

## Test-Driven Development

TDD is the default for everything. Work one tiny cycle at a time:

1. **Write one test that asserts one thing.**
2. **Run it and watch it fail** — for the right reason. A test you never saw fail
   proves nothing.
3. **Write the minimum code to make it pass.**
4. **Run the test and watch it pass.**
5. **Commit.**
6. Repeat with the next test.

One assertion per test. One test per commit cycle. No batching multiple behaviors
into a single test or a single commit.

---

## Commits

- A commit is normally **two files: the test file and the code file.**
- When implementing or updating an interface (e.g. a new controller endpoint) a
  commit may touch more files (route + controller + view) — that is the minimal
  coherent unit for that interface, and it is allowed.
- Keep each commit focused on the one behavior the test describes.

---

## What to Test

- **Test our own code only.**
- **Never test third-party code** — not a gem, not an API, not a framework. The
  only test that may reference a dependency is one that asserts *our system is
  correctly wired to it* (the integration seam), never the dependency's own
  behavior.
- **Never test another interface inside a unit test.** A test covers one interface.
  The single exception is the smoke integration test described below.

---

## Smoke Integration Test

When implementing an interface, write **one smoke integration test** that exercises
the interface end to end and proves the pieces are connected. This is the one place
where touching more than the unit under test is expected and correct.

---

## Pull Requests

- **Always work on a feature branch and open a PR.** Confirm the target branch
  before any git operation (`git branch --show-current`).
- **Keep PRs small and manageable** — typically **no more than 8–10 files.**
- Keep the focus of a PR narrow. One concern per PR.
- **All tests pass before opening the PR.**
- **The linter and every other CI check pass before opening the PR.**
- Never start a new PR until the previous one is merged.

---

## Code Quality

- Follow Clean Code principles: small functions, clear names, no surprises.
- Follow SOLID principles. Readable by a human first.
- Keep it simple — no abstraction until a real need calls for it.
- Explicitly require libraries rather than assuming autoload.

## Comments

- **Write self-documenting code, not comments.** Code should be clean and readable
  on its own. Names — of classes, methods, variables, and partials — carry the intent.
- **A comment is a smell.** If you feel a comment is needed, the code is either built
  wrong or needs refactoring (a clearer name, a smaller method, an extracted object or
  partial) so the intent is obvious without prose. Follow SOLID and this resolves itself.
- Do not leave explanatory headers on classes/methods, inline "what this does" notes,
  or section banners. Delete them and let the structure speak.
- Narrow exceptions, kept rare: a genuinely non-obvious *why* (a workaround for an
  external bug, a legal/security constraint) and machine-readable annotations the
  tooling requires (e.g. `rubocop:disable`). Prefer refactoring over a "why" comment
  whenever you can.
<!-- the_local:process:end -->





