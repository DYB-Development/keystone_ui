# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

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
