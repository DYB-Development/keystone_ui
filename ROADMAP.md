# Keystone UI Roadmap

## Shipped Components (36)

### Core
- **ui_button** — button/link with variants and sizes
- **ui_card** — card layout with title, summary, and CTA
- **ui_card_link** — clickable card wrapping content in an `<a>` tag
- **ui_badge** — inline status badge with color variants
- **ui_copy_button** — copy-to-clipboard button

### Layout
- **ui_page** — page wrapper with max-width and padding
- **ui_section** — content grouping with optional header and spacing
- **ui_grid** — CSS grid with responsive columns and gap sizes
- **ui_panel** — bordered container with padding, radius, and shadow

### Data Display
- **ui_data_table** — responsive data table with links, actions, and mobile-hidden columns
- **ui_stat_card** — metric card for dashboards
- **ui_chart_card** — card wrapper for chart content

### Forms
- **ui_form_field** — label, input, hint, and error in consistent layout
- **ui_input** — standalone text/number/email input
- **ui_textarea** — multi-line text input
- **ui_select** — styled select dropdown
- **ui_color_picker** — HSV color picker with swatch preview

### Page Structure
- **ui_page_header** — page title area with optional action slot
- **ui_alert** — flash messages with type variants and dismiss
- **ui_form_page** — form page wrapper with content_for signals
- **ui_show_page** — show page wrapper with content_for signals

### Navigation
- **ui_navbar** — top-level navigation bar with desktop/mobile slots
- **ui_nav_item** — single nav link with active state
- **ui_nav_dropdown** — dropdown menu within the navbar
- **ui_bottom_nav** — mobile bottom tab bar
- **ui_bottom_nav_item** — single bottom nav tab
- **ui_mobile_header** — mobile header with back link and title
- **ui_mobile_actions** — ellipsis dropdown for mobile action menus
- **ui_settings_link** — settings row link with chevron icon

### Interactive
- **ui_modal** — modal dialog with backdrop and size options
- **ui_accordion** — collapsible question/answer items
- **ui_tab_switcher** — tab bar with active state indicator
- **ui_option_card** — toggleable card option

### Marketing
- **ui_hero** — large hero section with split/centered layouts
- **ui_feature_grid** — grid of feature cards with icons
- **ui_cta_banner** — call-to-action banner

---

## Planned Components

Build as needed based on consuming application requirements.

### `ui_empty_state`
Placeholder for empty lists/collections with icon, title, description, and action.

### `ui_checklist_item`
Interactive item with checkbox, content, and actions for list UIs.

### `ui_progress`
Progress bar with label and percentage display.

### `ui_checkbox`
Standalone styled checkbox input.

### `ui_avatar`
User avatar with fallback initials.

### `ui_tooltip`
Hover tooltip for contextual help.

### `ui_dropdown_menu`
General-purpose action menu dropdown (distinct from nav dropdown).

### `ui_tabs`
URL-driven tab navigation with counts and active state.

---

## Development Guidelines

For each new component:

1. **Write spec first** — define expected behavior in RSpec (TDD)
2. **Build component class** — Ruby object with explicit kwargs, Tailwind utility classes via frozen constant hashes
3. **Create template** — minimal ERB referencing class constants
4. **Add helper** — thin wrapper in `keystone_ui_helper.rb`
5. **Document in README** — props and usage examples
6. **Update rake task** — add to `rake keystone:claude` output
7. **Test in consuming app** — verify in real usage context
