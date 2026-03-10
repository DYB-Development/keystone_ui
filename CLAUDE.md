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

## Accent Color System

KeystoneUi provides a configurable accent color palette that all components and consuming gems should use. This ensures a host app can set one accent color and have it propagate everywhere.

### How it works

1. **Host app configures accent** in an initializer:
```ruby
# config/initializers/keystone_ui.rb
KeystoneUi.configure do |c|
  c.accent = :emerald          # preset: :blue (default), :emerald, :cyan, :indigo, :violet, :rose
  # OR a custom hash (missing keys fall back to :blue defaults):
  c.accent = { text: "text-[#D4636D]", dark_text: "text-[#D4636D]" }
end
```

2. **Components use `AccentColors`** instead of hardcoded color classes:
```ruby
accent = KeystoneUi::AccentColors.current  # returns full palette hash
accent[:text]          # => "text-blue-600" (or whatever accent is configured)
accent[:focus_border]  # => "focus:border-blue-500"
```

3. **Consuming gems** (like Herald) wrap lookups in a helper module:
```ruby
# app/helpers/my_gem/theme_helper.rb
module MyGem
  module ThemeHelper
    def my_accent(key)
      KeystoneUi::AccentColors[key]
    end
  end
end
```
Then use `my_accent(:text)`, `my_accent(:focus_border)`, etc. in views instead of hardcoded Tailwind classes.

### Available palette keys

`border`, `bg`, `text`, `dark_text`, `hover_border`, `dark_hover_border`, `hover_text`, `dark_hover_text`, `badge_bg`, `badge_text`, `badge_dark_bg`, `badge_dark_text`, `alert_bg`, `alert_text`, `alert_dark_bg`, `alert_dark_text`, `solid_bg`, `solid_hover_bg`, `focus_border`, `focus_ring`, `dark_focus_border`, `dark_focus_ring`, `link_text`, `link_hover_text`, `link_dark_text`, `link_dark_hover_text`, `checkbox`, `checkbox_focus`

### CSS source generation

The engine uses `config.after_initialize` to write a `keystone_source.css` file containing `@source inline()` directives. This tells Tailwind to compile dynamic palette classes that can't be discovered from static file scanning. Host apps and dependent engines don't need any extra configuration — it happens automatically on boot.

## Key Conventions

- Ruby >= 3.1.0 required.
- Components live under the `Keystone::Ui` namespace.
- The DataTableComponent uses Tailwind CSS utility classes with predefined position-based class constants (first/middle/last cell styling). It accepts `items` (AR objects or hashes) and `columns` (simple `{ key: "Label" }` hashes or `Keystone::Ui::Column` objects), resolving cell values automatically. `Column` objects support per-column options like `mobile_hidden: true` which appends `hidden sm:table-cell` classes. A block-based API registers links via `table.link(:column_key) { |item| url }` and actions via `table.actions { |item| ... }`. When an actions column is present, position classes shift so the actions column gets LAST styling.
- GridComponent uses a `COL_CLASSES` frozen hash mapping `{breakpoint => {count => "literal-class"}}` for cols 1-12 across `default`, `sm`, `md`, `lg` breakpoints. All Tailwind classes are complete static strings (never interpolated) so the JIT scanner can detect them. Gap classes use the same pattern via `GAP_CLASSES`, `GAP_X_CLASSES`, and `GAP_Y_CLASSES` constants.
- ButtonComponent conditionally renders `<a>` or `<button>` based on whether `href` is provided.
- NavbarComponent is the top-level navigation bar with slots for `logo`, `desktop_links`, `desktop_right`, `mobile_left`, `mobile_center`, and `mobile_right`. Supports `sticky: true` (default) for fixed positioning. Mobile sections are hidden on `lg:` screens and vice versa.
- NavDropdownComponent renders a dropdown menu within the navbar. Accepts `title`, `area`, and `active` flag. Uses Stimulus `dropdown` controller for toggle behavior.
- NavItemComponent is a single nav link with `label`, `href`, and `active` state.
- BottomNavComponent renders a mobile bottom tab bar, hidden on desktop (`lg:hidden`).
- BottomNavItemComponent is a single bottom nav tab with `label`, `href`, `icon` (SVG string), and `active` state.
- MobileHeaderComponent renders a mobile header with back link, centered title, and optional subtitle. Hidden on `lg:` screens.
- MobileActionsComponent renders an ellipsis dropdown for mobile action menus. Hidden on `lg:` screens. Uses Stimulus `dropdown` controller.
- FormPageComponent wraps form pages with `title`, `back_url`, and optional `subtitle`. Sets `content_for` signals (`:form_page`, `:form_page_title`, `:form_page_back_url`) so the navbar can render mobile header context.
- ShowPageComponent wraps show pages with `title`, `back_url`, and optional `subtitle`. Sets `content_for` signals (`:show_page`, `:show_page_title`, `:show_page_back_url`, `:show_page_subtitle`).
- SettingsLinkComponent renders a gear icon link for settings navigation.
- All CSS classes must be in frozen constants (not inline strings) so the safelist generator can extract them. SVG icon constants (`ELLIPSIS_ICON`, `BACK_ICON`, `CARET_ICON`) are excluded from safelist scanning via `SKIP_CONSTANTS`.
