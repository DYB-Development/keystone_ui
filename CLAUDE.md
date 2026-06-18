# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Keystone UI is a Rails gem providing reusable UI components built on `view_component`. It provides UI primitives that avoid ERB noise, prevent UI drift, and enable safe mass updates.

## Commands

```bash
bundle install              # Install dependencies
bundle exec rspec           # Run all tests
bundle exec rspec spec/keystone/ui/button_component_spec.rb  # Run a single test file
rake keystone:claude        # Append API reference to consuming app's CLAUDE.md
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

Tests use RSpec. The spec helper stubs `ViewComponent::Base` so tests run without a full Rails environment. Tests validate component logic (class composition, tag options, normalization) rather than rendered HTML.

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
