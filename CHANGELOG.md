# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [0.14.0] - 2026-09-24

### Added
- A gem can supply custom as the theme mode, and the page is marked custom.

## [0.13.0] - 2026-09-24

### Fixed
- A funnel's labels, values and step-to-step percents, and a progress bar's track and label, are readable on a dark page.

### Added
- A bucket shows an amount against a goal as an upright container filled from the bottom, with the goal, the amount and the percent reached.
- A bucket series shows several buckets in a row that wraps on narrow screens.
- Each funnel step draws its bar in its own colour, taken in order from a palette of five, and a step can name the palette colour it wants.

## [0.12.2] - 2026-09-21

### Fixed
- A stat card is the same height whether or not it has a change to show. A card whose value cannot be read drew no change line at all, so it stood about twenty pixels shorter than the cards beside it.

## [0.12.1] - 2026-09-17

### Fixed
- **Radio card on a dark page** — a radio card's label is drawn in a colour that reads on a dark page, and a chosen card is visibly the chosen one there
- **Radio card width** — a radio card sizes to its own content, so a row of them sits side by side and wraps, instead of each filling the width

## [0.12.0] - 2026-09-15

### Added
- **`class:` on page, page header, section, card, alert and badge** — pass extra classes for one use, for example `ui_card(title: "Revenue", summary: "$42k", link: reports_path, class: "mt-8")`, and they are added to the component's outer element

### Changed
- **Shared classes** — page, page header, section, card, alert and badge render keystone_ui-styles' shared `ks-` classes, so React versions rendering the same classes look identical and a host can restyle them by overriding one class. They look the same as before.
- Requires keystone_ui-styles 0.2.0 or later

## [0.11.1] - 2026-09-14

### Fixed
- **Leftover generated stylesheet** — a host app that ran its Tailwind build with keystone_ui 0.10.0 or earlier no longer keeps `app/assets/builds/tailwind/keystone_ui_engine.css` after upgrading. keystone_ui deletes that file when the host app boots, and leaves the folder's other files alone.

### Upgrading
- No manual step for `keystone_ui_engine.css`. The 0.11.0 advice to run `rails tailwindcss:clobber` did not remove files in `app/assets/builds/tailwind`.

## [0.11.0] - 2026-09-14

### Added
- **`tailwind_imports` and `tailwind_sources` settings** — a gem built on keystone_ui registers its CSS files and the files Tailwind should scan, and `keystone_source.css` includes them, so hosts need no other stylesheet import

### Fixed
- **Generated stylesheet** — hosts no longer get `app/assets/builds/tailwind/keystone_ui_engine.css`. With `stylesheet_link_tag :app`, that file made the browser request a path inside the installed gem and raise a routing error. The grid column safelist now comes in through `keystone_source.css`.

### Upgrading
- Delete leftover files in `app/assets/builds/tailwind` for keystone gems, or run `rails tailwindcss:clobber` once.

## [0.10.0] - 2026-09-14

### Added
- **`theme_mode_supplier` setting** — another gem can supply a light, dark or system mode that applies when the browser has no toggle choice

### Changed
- **Light and dark mode** — a page renders light when there is no toggle choice and no supplied mode, instead of following the operating system
- **ThemeToggleComponent** — picking System is remembered in the `keystone_theme` cookie like Light and Dark, and the toggle shows the mode the page renders in as pressed

### Upgrading
- Pages that followed the operating system by default now render light. Users who want the operating system's setting pick System on the toggle.

## [0.9.1] - 2026-09-14

### Fixed
- **CheckboxRowComponent** — the label and hint stay readable in dark mode, and a checked box fills with the accent color even when host app styles set a checkbox background

## [0.9.0] - 2026-09-14

### Added
- **CheckboxRowComponent** (`ui_checkbox_row`) — a checkbox with a label and optional hint that sends its `value` under `name`, so several rows can share an array name like `shown[]`; the whole row is clickable

## [0.8.0] - 2026-09-14

### Added
- **ThemeToggleComponent** (`ui_theme_toggle`) — Light, Dark and System buttons that switch the page's mode at once and keep the choice in a `keystone_theme` cookie (`theme-toggle` Stimulus controller)
- **`keystone_theme_attributes` helper** — marks the `html` tag with the stored choice so pages open in that mode with no flash; the install generator adds it to the application layout

### Changed
- **Styling** — keystone_ui now depends on keystone_ui-styles, which defines the accent and surface color variables, light and dark mode, and the classes the button, panel, input, text area, select and form field components render. `keystone_source.css` imports it at boot, so hosts change nothing.
- **Light and dark mode** — keystone_ui decides dark mode for the whole app, including `dark:` classes in host views. A page follows the operating system unless the `html` element carries `data-theme="dark"` or `data-theme="light"`.
- **FormFieldComponent** — inputs, text areas and selects it renders now show the accent focus ring, like the standalone input components.

### Removed
- **`theme.css`** — the color variables now come from keystone_ui-styles, with the same default values.

### Upgrading
- Remove any `@custom-variant dark` your app declares in `application.css`. keystone_ui's dark mode rule now applies to your own classes, and a variant declared after the keystone import would replace it.

## [0.7.0] - 2026-09-13

### Added
- **StatCardComponent** — optional `href:` turns the value into a link; the card stays unlinked so its info button keeps working

### Changed
- **StatCardComponent** — the definition and calculation details float in a panel below the card while the info button is hovered or focused, instead of expanding the card; tapping the button still toggles the panel

### Fixed
- **Packaging** — the built gem now includes `MIT-LICENSE`

## [0.6.0] - 2026-07-31

### Added
- **DisclosureComponent** (`ui_disclosure`) — a single collapsible panel (native `<details>`/`<summary>`, no JS) with a `summary` slot and an arbitrary body block. Unlike `ui_accordion` (which only takes single-line `{question:, answer:}` items), its body can hold grids, prose, and code. `open:` pre-expands it. Built for explorable "ladder"/reference docs.
- **CodeComponent** (`ui_code`) — styled `<pre><code>` block (monospace, horizontal scroll) with optional `language:` (tags the `<code>` with `language-<lang>` for optional highlighting) and `caption:` (a filename/label bar above the block).
- **StatCardComponent** — optional `definition:` and `calculation:` params surface a metric's meaning and formula via an info (`i`) button that toggles a disclosure panel (Stimulus `stat-card-info` controller)
- **StatCardComponent** — optional `change:` param shows a period-over-period trend (▲/▼ + percent), colored by sign
- **`auto-submit` Stimulus controller** — submits its form on change (`requestSubmit`), for filter selects that update without an explicit submit button
- **LineChartComponent** — per-series styling: a series entry accepts `color:` (any CSS color, or an accent token like `var(--color-accent-500)` — resolved to a concrete color in the `line-chart` controller so the accent/surface palette works on canvas) and `dashed: true` (dashed line). The existing `{ name:, data: }` form is unchanged.
- **LineChartComponent** (`ui_line_chart`) — responsive multi-series line chart (Chart.js, `line-chart` controller); mobile- and hotwire-native-safe (destroys the chart on `disconnect`). Chart.js is bundled and pinned by the gem — no host setup.
- **Install generator** — `keystone:install` now wires `registerControllers(application)` into the host app's `app/javascript/controllers/index.js`, so interactive components work without manual JS setup

### Changed
- **view_component dependency** — now `>= 2.0", "< 5`. The requirement was open-ended, so a future major with breaking changes would have resolved and broken installs.
- **the_local** — migrated from the register-based companion to the manifest-based provider model. The gem now carries no Ruby for the_local: `the_local/interface.yml` declares the public surface and `rake the_local:author` renders `the_local/agents/*.md`, which the gemspec ships. Requires `the_local ~> 0.4`.

### Removed
- **`keystone:claude` rake task** — dropped the legacy CLAUDE.md API-reference generator (and the install generator's `generate_claude_docs` step that ran it). `the_local` now ships this guidance as resident `keystone_ui-*` locals, so nothing invoked the task.
- **`KeystoneUi::Companion` and `KeystoneUi::Reference`** — the register-based the_local companion and its reference loader, along with `lib/keystone_ui/reference/guide.md` and the locals rendered under `lib/`. Replaced by the committed `the_local/` directory.
- **`keystone:inject_source` / `keystone:clean_source` rake tasks** — they rewrote the `/* keystone:source */` marker that the install generator now strips as legacy, so they were inert against any current install.
- **`KeystoneUi::Current`** — an `ActiveSupport::CurrentAttributes` seam (`accent_override`, `surface_override`) referenced by nothing in the gem or any consumer.

### Fixed
- **Packaging** — `config/importmap.rb` is now included in the built gem. The engine pins it at boot for importmap host apps, but `spec.files` only globbed `lib/**/*` and `app/**/*`, so it shipped missing; a regression test asserts it's packaged.
- **Importmap** — pin the `stat_card_info_controller` (it was imported by `index.js` but unpinned, which broke `registerControllers` in importmap host apps); added a regression test asserting every controller is pinned
- **Importmap** — bundle and pin `chart.js`. The `line-chart` controller imported it but nothing provided it, so the import failed and took down the whole `registerControllers` bundle in host apps. Vendored as a self-contained build; regression test asserts it's pinned.
- **LineChartComponent** — mobile horizontal overflow: the responsive canvas pushed the page wider than the viewport. The container is now `position: relative` + `min-w-0` and the canvas `max-w-full`, so the chart fits the screen.
- **HeroComponent** — `layout: :centered` now centers the badge, subtitle, and button row (not just the title). The inner content column carries `items-center` only in the centered layout.

## [0.5.0] - 2026-05-07

### Added
- **FormComponent** — `<form>` wrapper with `action:`, `method:` (with Rails-style `_method` override for patch/put/delete), `multipart:`, and `data:` attributes
- **FileUploadComponent** — styled file input with clickable drop zone, drag-and-drop support, file name feedback, accepted file types, multiple file support, and hint text (Stimulus `file-upload` controller)
- **Stimulus controllers** — added 6 missing controllers: `dropdown`, `dismiss`, `modal`, `clipboard`, `tab-switcher`, `accordion`
- **DataTableComponent** — sortable column headers: `sortable: true` on Column, `sort:`, `sort_direction:`, `sort_url:` params render clickable `<a>` headers with arrow icons and `data-turbo-action="replace"`
- **DataTableComponent** — hidden columns: `hideable: true` on Column, `hidden_columns:` param filters columns server-side
- **ColumnPickerComponent** — dropdown with checkboxes for toggling hideable column visibility, with optional PATCH persistence via `save_url:` (Stimulus controller)
- **SelectComponent** — styled `<select>` dropdown with options, selected value, include_blank, and disabled states
- **BadgeComponent** — inline status badge with variants (neutral/success/danger/warning/info)
- **StatCardComponent** — metric card for dashboards with label, value, suffix, and color variants
- **ChartCardComponent** — card wrapper for chart content with configurable height (sm/md/lg)
- **CopyButtonComponent** — copy-to-clipboard button with success/error messages
- **ModalComponent** — modal dialog with title, close button, backdrop, and size options (sm/md/lg/xl)
- **AccordionComponent** — collapsible question/answer items
- **TabSwitcherComponent** — tab bar with active state indicator (Stimulus controller)
- **OptionCardComponent** — toggleable card option for radio-like selection
- **HeroComponent** — large hero section with split/centered layouts and aside slot
- **FeatureGridComponent** — grid of feature cards with icons, title, and description
- **CtaBannerComponent** — call-to-action banner with title, subtitle, and action buttons
- **ColorPickerComponent** — HSV color picker with swatch preview (Stimulus controller)
- **NavbarComponent** — top-level navigation bar with slots for desktop and mobile sections
- **NavItemComponent** — single nav link with active state
- **NavDropdownComponent** — dropdown menu within the navbar (Stimulus controller)
- **BottomNavComponent** — mobile bottom tab bar, hidden on desktop
- **BottomNavItemComponent** — single bottom nav tab with icon and active state
- **MobileHeaderComponent** — mobile header with back link, centered title, and subtitle
- **MobileActionsComponent** — ellipsis dropdown for mobile action menus
- **FormPageComponent** — form page wrapper with `content_for` signals for navbar context
- **ShowPageComponent** — show page wrapper with `content_for` signals for navbar context
- **SettingsLinkComponent** — settings row link with chevron icon
- Complete README documentation for all 36 components
- Complete `rake keystone:claude` output for all 36 components

### Fixed
- Install generator creates `application.css` when missing (no longer requires `tailwindcss:install` first)
- AlertComponent dismiss button now wires `data-controller="dismiss"` on wrapper
- CopyButtonComponent template now includes `click->clipboard#copy` action
- BadgeComponent and StatCardComponent `:info` variant moved into `VARIANT_CLASSES` constant (was inline, invisible to safelist)
- ShowPageComponent now has frozen constants and `subtitle?` method (matches FormPageComponent pattern)

## [0.4.1] - 2026-02-11

### Fixed
- Resolved bundle dependency issue requiring force-resolve on version bump

## [0.4.0] - 2026-02-11

### Added
- **PageHeaderComponent** — page title area with optional action slots
- **AlertComponent** — flash messages and inline notifications with type variants and optional dismiss
- Safelist auto-generation from component constants

### Fixed
- Install generator auto-injects CSS import without prompting
- Railtie initializer injects `@source` path at boot time (replaces inline safelist approach)
- Generator cleans up legacy import and safelist lines on upgrade

## [0.3.0] - 2026-02-10

### Added
- **InputComponent** — standalone text/number/email input with base Tailwind classes
- **TextareaComponent** — multi-line text input
- **FormFieldComponent** — wraps label, input, hint, and error in consistent layout

## [0.2.0] - 2026-02-09

### Added
- **CardLinkComponent** — clickable card wrapping content in an `<a>` tag
- **PageComponent** — page wrapper with max-width and responsive padding
- **SectionComponent** — content grouping with optional header and spacing
- **GridComponent** — CSS grid with responsive columns and gap sizes (static `COL_CLASSES` hash)
- **PanelComponent** — bordered container with padding, radius, and shadow options
- Split gap support (`gap_x`/`gap_y`) for GridComponent
- `rake keystone:claude` task for generating API reference in consuming apps
- Install generator for host app setup
- GitHub Actions CI workflow

### Fixed
- DataTable styling: consistent rounding, padding, and borders
- Card and Button components converted from custom CSS to Tailwind utilities

## [0.1.0] - 2026-02-08

### Added
- **CardComponent** — card layout with title, summary, and CTA
- **ButtonComponent** — button/link with variants (primary/secondary/danger) and sizes
- **DataTableComponent** — responsive data table with block-based link and actions API
  - Column objects with `mobile_hidden` option
  - Position-based cell styling (first/middle/last)
