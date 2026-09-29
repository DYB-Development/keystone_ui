# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Keystone UI is a Rails gem providing reusable UI components built on `view_component`. It provides UI primitives that avoid ERB noise, prevent UI drift, and enable safe mass updates.

## Commands

```bash
bundle install              # Install dependencies
bundle exec rake            # Run the component tests and the template rendering tests
bundle exec rake test       # Run the component tests
bundle exec rake test TEST=test/keystone/ui/button_component_test.rb  # Run a single test file
bundle exec rake test:render  # Run the template rendering tests
npm install                 # Install JavaScript test dependencies
npm test                    # Run the Stimulus controller tests
```

No build step or linter is configured.

## Architecture

This is a Rails engine gem structured around ViewComponent. The three-layer architecture is:

1. **Components** (`app/components/keystone/ui/`) — Ruby classes inheriting `ViewComponent::Base` with explicit keyword arguments, paired with `.html.erb` templates. All UI logic lives here.
2. **Helpers** (`app/helpers/keystone_ui_helper.rb`) — Thin render wrappers that delegate to components. Helpers contain no logic or conditionals. Consuming apps use helpers, not component classes directly.

Components use Tailwind CSS utility classes directly. At boot the engine writes `keystone_source.css` into the host through `KeystoneUi::SourceCss`: it imports keystone_ui-styles, points Tailwind at the component files, imports the color picker and grid safelist CSS, and adds whatever other gems registered in `KeystoneUi.configuration.tailwind_imports` and `tailwind_sources`. No file lives at `app/assets/tailwind/keystone_ui_engine/engine.css`, so tailwindcss-rails writes no generated stylesheet for keystone_ui. Host apps require `tailwindcss-rails` v4+.

## Design Principles

- All UI lives in ViewComponents (no partials).
- Components are Ruby objects with explicit keyword arguments.
- Helpers are thin render wrappers with no logic or conditionals.
- Styling uses Tailwind CSS utility classes applied directly in components.

## Testing

Ruby tests use Minitest. Stimulus controller tests live in `test/javascript` and run with Node's built-in test runner through `npm test`. The test helper stubs `ViewComponent::Base` so tests run without a full Rails environment. Those tests validate component logic (class composition, tag options, normalization) rather than rendered HTML.

Template rendering tests live in `test/render` and run through `rake test:render`, in a separate process from the rest. `test/render_helper.rb` boots a minimal Rails app with the real ViewComponent, and each test calls `render_inline` and reads the returned HTML with Nokogiri. A test that checks what a template outputs belongs there.

## Color System

Components use semantic CSS custom properties (`--color-accent-*`, `--color-surface-*`) via Tailwind classes like `bg-accent-500`, `text-accent-600`, etc. The keystone_ui-styles gem sets default values, defines light and dark mode, and holds the `ks-` classes the button, panel and form field components render. Host apps can override these via CSS, or use the `keystone_ui-colors` gem for per-user theming. Buttons, panels, cards, alerts, badges, form fields, the modal, the mobile action menu, the column picker, multi select, copy button, theme toggle, checkbox row, radio card, option card, file upload, colour picker, the navigation components (navbar title, nav item, nav dropdown, bottom nav, mobile header and settings link) and the data display components (stat card, chart card, card link, CTA banner, feature grid, hero, data table, code, accordion, disclosure, tab switcher, progress, funnel, bucket, pipeline and swipe deck) render keystone_ui-styles' `ks-` classes, which read `--ks-` variables for colour, radius, font, weight, shadow, border and spacing. Their constants keep only layout, size and behaviour utilities, so a look file that sets those variables restyles them. The README shows one.

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
- FormPageComponent wraps form pages with `title`, `back_url`, and optional `subtitle`. Sets `content_for` signals (`:form_page`, `:form_page_title`, `:form_page_back_url`) so the navbar can render mobile header context. Hands DesktopBackLinkComponent for `back_url`, or BreadcrumbsComponent ending with `title` when given a `trail`, to `content_for(:keystone_page_header)`, which PageComponent shows at its top. With no `trail`, it asks `KeystoneUi.configuration.trail_supplier` for one, and with no `back_url` it uses the trail's last link. Its desktop title block goes there too, after them.
- ShowPageComponent wraps show pages with `title`, `back_url`, and optional `subtitle`. Sets `content_for` signals (`:show_page`, `:show_page_title`, `:show_page_back_url`, `:show_page_subtitle`). Hands DesktopBackLinkComponent for `back_url`, or BreadcrumbsComponent ending with `title` when given a `trail`, to `content_for(:keystone_page_header)`, which PageComponent shows at its top. With no `trail`, it asks `KeystoneUi.configuration.trail_supplier` for one, and with no `back_url` it uses the trail's last link.
- BreadcrumbsComponent (`ui_breadcrumbs`) renders `trail`, an array of `[label, href]` pairs, as links separated by `›`, then the optional `current` page unlinked with `aria-current="page"`. Shown only on `lg:` screens, as a line of text so the steps keep their spaces, in the `ks-mobile-header-back` style.
- DesktopBackLinkComponent renders a link to `url` with the back arrow and the word "Back", shown only on `lg:` screens where MobileHeaderComponent is hidden. It uses the mobile back link's `ks-mobile-header-back` class and has no helper.
- SettingsLinkComponent renders a gear icon link for settings navigation.
- CheckboxRowComponent (`ui_checkbox_row`) renders a real `<input type="checkbox">` with a label and optional `hint` inside one `<label>`, so the whole row toggles the box. It sends `value` under `name`, so rows sharing an array name like `shown[]` submit the checked values. Supports `checked:` pre-selection. No Stimulus.
- ProgressComponent renders a labeled progress bar. `percent` is `value / max * 100` rounded and **clamped at 100**; an optional `label` caption renders above a rounded track. The bar width is applied via inline `style="width: N%"` (not a Tailwind class).
- RadioCardComponent renders a selectable card backed by a real `<input type="radio">` (visually `sr-only`); the selected state is pure CSS via `peer-checked:` styling (no Stimulus). Supports an optional `hint` sub-label and `checked:` pre-selection.
- PipelineComponent renders an interactive staged-flow diagram — a row of `boxes` connected by breakable `links` — for mapping event flows, data pipelines, approval chains, or state machines. The component owns the look and the post-to-endpoint contract; the host supplies data and handles the posts. Each box has a `label`, optional `count` + `accent` (`:amber`/`:emerald`/`:danger`/`:muted`, mapped onto the keystone palette), and an optional `action` that POSTs to a `url` with hidden `params` (rendered via `ui_button`). `links` has one fewer entry than `boxes`; each link's ✓/✗ toggle POSTs to flip its `broken` state. Boxes stack vertically with connectors shown between them on mobile, laying out horizontally on `sm+`. All classes are frozen constants. (Code-snippet boxes, dead-letter offshoots, badge, and title link are deferred follow-ups.)
- FunnelComponent renders a conversion funnel for analytics/stats pages. The top layer spans 100% width; each lower layer's bar width is relative to the **first** step's value (applied via inline `style="width: N%"`). Each layer's label and value sit on a full-width row **above** the bar so they stay legible at any depth on mobile/hotwire-native webviews; transitions between layers show the **step-to-step** conversion percent (`value / previous step's value`). Each bar takes the next colour from `STEP_COLOR_CLASSES` (accent, sky, violet, amber, rose), starting again after the last; a step passing `color:` with one of those names uses that colour instead. Divide-by-zero safe, no JS. The component is pure — compose a lazy `turbo_frame_tag` per funnel for async stats loading.
- BucketComponent (`ui_bucket`) renders an upright container standing for `goal:`, filled from the bottom to `actual:` via inline `style="height: N%"`. `goal` and `actual` must be numbers, and a string such as `"9,000"` raises `ArgumentError`. It prints them as given, with no thousands separators, the percent reached (`actual / goal * 100` rounded, **not** clamped, zero for a zero goal) and an optional `label`. The fill height stops at 100%; over the goal the fill turns green, or amber with `over: :warning`. BucketSeriesComponent (`ui_bucket_series(buckets:)`) renders one bucket per hash in `buckets:`, in a row that wraps on narrow screens.
- ThemeToggleComponent (`ui_theme_toggle`) renders Light, Dark and System buttons wired to the `theme-toggle` Stimulus controller, which sets `data-theme` on the `html` element and stores the choice in the `keystone_theme` cookie. `KeystoneUi::ThemeChoice` decides the mode on the server: the cookie's choice, then a mode another gem supplies through `KeystoneUi.configuration.theme_mode_supplier`, then light. `keystone_theme_attributes` writes that mode onto the layout's `html` tag, and System leaves the tag unmarked so the page follows the operating system. `registerControllers` also listens for Turbo renders and copies `data-theme` from the page about to be shown, since Turbo keeps the first page's `html` attributes. A supplied `custom` mode marks the tag `data-theme="custom"`; the toggle does not offer it.
- Component constants hold keystone_ui-styles' `ks-` classes for how a component looks, plus only layout, size, font size and behaviour utilities. `test/keystone/component_look_guard_test.rb` fails and names the component, constant and utility when a constant holds a colour, radius, font weight, shadow, border or spacing utility, because such a utility would override the `ks-` class a look file restyles.
- All CSS classes must be in frozen constants (not inline strings) so the safelist generator can extract them. SVG/HTML icon constants (`ELLIPSIS_ICON`, `BACK_ICON`, `CARET_ICON`, `SORT_ASC_ICON`, `SORT_DESC_ICON`, `SORT_NEUTRAL_ICON`, `COLUMNS_ICON`) are excluded from safelist scanning via `SKIP_CONSTANTS`.

<!-- the_local:begin -->
## Delegate to your locals

This project has installed expert subagents. Before doing work yourself,
check whether a local owns it and delegate — never work from memory on
something a local covers:

- resident Claude Code experts — authoring a gem's locals and installing them into a host → the_local-* agents

See each agent's description for specifics.
<!-- the_local:end -->
