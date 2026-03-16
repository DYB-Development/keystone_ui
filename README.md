# Keystone UI

Keystone UI is a reusable UI component system for Rails applications built on the
`view_component` gem. It provides stable, authoritative UI primitives that avoid ERB noise,
prevent UI drift, and enable safe mass updates.

## Principles

- All UI lives in ViewComponents (no partials).
- Components are Ruby objects with explicit keyword arguments.
- Helpers are thin render wrappers with no logic or conditionals.
- Styling uses Tailwind CSS utility classes applied directly in components.

## Installation

### Prerequisites

- Rails 7+
- **tailwindcss-rails v4+**

### Steps

1. Add the gem to your Gemfile:

```ruby
gem "keystone_ui"
```

2. Run `bundle install`.

3. Run the install generator:

```bash
rails generate keystone:install
```

The generator handles setup automatically:

- If `app/assets/tailwind/application.css` **does not exist**, the generator creates it with the Tailwind import and Keystone source import. No need to run `tailwindcss:install` first.
- If it **already exists**, the generator injects the Keystone source import after the existing Tailwind import line.

At boot time, the engine initializer writes `keystone_source.css` with `@source` directives pointing to the gem's component files so Tailwind scans them automatically.

### How Tailwind integration works

- The generator commits only an `@import "./keystone_source.css"` line — no machine-specific paths in git.
- On every app boot (dev server, `assets:precompile`, CI), the engine writes
  `keystone_source.css` with `@source` and theme `@import` directives.
- Tailwind's JIT scanner finds all component classes automatically.
- When keystone updates with new components, they're picked up on the next build
  with no action required.

### Upgrading from older versions

Re-run the generator. It removes legacy `@import` and `@source inline(...)` lines
automatically:

```bash
rails generate keystone:install
```

## Color System

Keystone UI components use two semantic color scales — **accent** and **surface** — defined as CSS custom properties. Components reference these via Tailwind classes like `bg-accent-500`, `text-accent-600`, `bg-surface-100`, etc. This means your entire UI updates when you change the color values — no need to touch component code.

### Defaults

The gem ships a `theme.css` that sets default values (imported automatically by the engine initializer):

| Scale | Default palette | Used for |
|-------|----------------|----------|
| `accent` | Blue (`#3b82f6` at 500) | Buttons, links, focus rings, active states, badges |
| `surface` | Zinc (`#71717a` at 500) | Backgrounds, borders, text on dark mode surfaces |

Each scale provides shades 50-950, matching Tailwind's standard shade range.

### Customizing colors

Override the CSS custom properties in your app's `application.css` (after the Tailwind import):

```css
@import "tailwindcss";
@import "./keystone_source.css";

@theme {
  /* Override accent to indigo */
  --color-accent-50: #eef2ff;
  --color-accent-100: #e0e7ff;
  --color-accent-200: #c7d2fe;
  --color-accent-300: #a5b4fc;
  --color-accent-400: #818cf8;
  --color-accent-500: #6366f1;
  --color-accent-600: #4f46e5;
  --color-accent-700: #4338ca;
  --color-accent-800: #3730a3;
  --color-accent-900: #312e81;
  --color-accent-950: #1e1b4e;
}
```

You only need to override the shades you use. All Keystone components will pick up the new colors automatically.

### Per-user theming

For dynamic, per-user color customization (e.g. letting users pick their own accent color), see the [`keystone_colors`](https://github.com/tylercschneider/keystone_colors) gem, which generates the CSS custom properties from user preferences at runtime.

## Helper API (primary surface)

Use the helpers in ERB. Consuming apps should not instantiate components directly.

```erb
<%= ui_card(
  title: "Revenue",
  summary: "$42,300 this month",
  link: reports_path
) %>

<%= ui_button(
  label: "Create invoice",
  href: new_invoice_path,
  variant: :primary
) %>

<%= ui_data_table(
  items: @products,
  columns: [
    { name: "Name" },
    { quantity: "Quantity" },
    { price: "Price" }
  ],
  empty_message: "No products found."
) do |table| %>
  <% table.link(:name) { |item| product_path(item) } %>
<% end %>
```

## Available Components

### `ui_card`

Renders a card layout with a title, summary, and a single call-to-action link.

**Required props**

- `title:` (String)
- `summary:` (String)
- `link:` (String or URL)

**Optional props**

- `cta:` (String, default `"Read more"`)
- `edge_to_edge:` (Boolean, default `false`) — when `true`, removes horizontal border-radius and side borders on mobile, restoring them at the `sm` breakpoint. Useful for cards that span the full viewport width on small screens.

### `ui_button`

Renders a deterministic button or link. If `href` is present, an `<a>` tag is rendered.
Otherwise, a `<button>` tag is rendered with `type="button"`.

**Required props**

- `label:` (String)

**Optional props**

- `href:` (String or URL)
- `variant:` (`:primary | :secondary | :danger`, default `:primary`)
- `size:` (`:sm | :md | :lg`, default `:md`)

### `ui_data_table`

Renders a responsive data table. Accepts a collection of items (ActiveRecord objects, Structs, or hashes) and column definitions that map lookup keys to header labels.

**Required props**

- `items:` (Array) — collection of AR objects, Structs, or hashes
- `columns:` (Array of Hashes or `Column` objects) — each hash maps a lookup key to a header label, e.g. `{ name: "Name" }`. Use `Keystone::Ui::Column` for per-column options.

**Optional props**

- `empty_message:` (String) — message displayed when `items` is empty
- `sort:` (Symbol/String) — current sort column key
- `sort_direction:` (Symbol) — `:asc` or `:desc`
- `sort_url:` (Lambda) — `(col, dir) → url` for generating sort links
- `hidden_columns:` (Array) — column keys to hide (only affects `hideable` columns)

**Column options**

`Keystone::Ui::Column.new(key, header_text, mobile_hidden: false, sortable: false, hideable: false)`

| Option | Default | Description |
|--------|---------|-------------|
| `mobile_hidden:` | `false` | hide on small screens (`hidden sm:table-cell`) |
| `sortable:` | `false` | render header as clickable sort link |
| `hideable:` | `false` | allow hiding via `hidden_columns:` / column picker |

**Mobile-hidden columns**

Use `Keystone::Ui::Column` objects to hide columns on mobile. Columns with `mobile_hidden: true` receive `hidden sm:table-cell` classes, hiding them on small screens and showing them from the `sm` breakpoint up. Columns are visible on mobile by default.

```erb
<%= ui_data_table(
  items: @products,
  columns: [
    Keystone::Ui::Column.new(:name, "Name"),
    Keystone::Ui::Column.new(:quantity, "Quantity", mobile_hidden: true),
    Keystone::Ui::Column.new(:price, "Price")
  ]
) %>
```

**Sortable columns**

Mark columns as `sortable: true` and pass `sort:`, `sort_direction:`, and `sort_url:` to render clickable header links with sort arrows. Sort links use `data-turbo-action="replace"` for clean Turbo navigation. Toggle logic: active asc → desc, active desc → asc, inactive → asc.

```erb
<%
  columns = [
    Keystone::Ui::Column.new(:name, "Name", sortable: true),
    Keystone::Ui::Column.new(:quantity, "Quantity", mobile_hidden: true),
    Keystone::Ui::Column.new(:price, "Price", sortable: true)
  ]
%>
<%= ui_data_table(
  items: @products,
  columns: columns,
  sort: params[:sort],
  sort_direction: params[:direction],
  sort_url: ->(col, dir) { products_path(sort: col, direction: dir) }
) %>
```

**Hidden columns**

Mark columns as `hideable: true` and pass `hidden_columns:` to filter them out server-side. Non-hideable columns are always shown even if listed in `hidden_columns:`.

```erb
<%= ui_data_table(
  items: @products,
  columns: columns,
  hidden_columns: current_user.hidden_columns_for(:products)
) %>
```

**Linkable cells**

Register links via `table.link(:column_key)` in the block. The block receives the current item and must return a URL string. The cell's value is wrapped in an `<a>` tag.

```erb
<%= ui_data_table(
  items: @products,
  columns: [
    { name: "Name" },
    { quantity: "Quantity" },
    { price: "Price" }
  ]
) do |table| %>
  <% table.link(:name) { |item| product_path(item) } %>
<% end %>
```

**Actions column**

Pass a block to add a trailing "Actions" column. The block receives the component instance; call `actions` on it with a sub-block that receives each item.

```erb
<%= ui_data_table(
  items: @products,
  columns: [
    { name: "Name" },
    { status: "Status" }
  ]
) do |table| %>
  <% table.link(:name) { |item| product_path(item) } %>
  <% table.actions do |item| %>
    <%= link_to "Edit", edit_product_path(item) %>
    <%= link_to "Delete", product_path(item), data: { turbo_method: :delete } %>
  <% end %>
<% end %>
```

When an actions column is present, position-based styling classes shift automatically — the last data column receives middle styling and the actions column receives last styling.

### `ui_column_picker`

Renders a "Columns" dropdown button with checkboxes for showing/hiding `hideable` columns. Pair with `ui_data_table`'s `hidden_columns:` param.

**Required props**

- `columns:` (Array of `Column` objects) — same array passed to `ui_data_table`

**Optional props**

- `hidden_columns:` (Array) — currently hidden column keys
- `save_url:` (String) — PATCH endpoint to persist preferences; omit for no persistence

On checkbox change, the Stimulus `column-picker` controller PATCHes `{ hidden_columns: [...] }` as JSON to `save_url`, then reloads via `Turbo.visit`.

```erb
<%= ui_column_picker(
  columns: columns,
  hidden_columns: @hidden_columns,
  save_url: table_preferences_path("products")
) %>
```

### `ui_page`

Wraps page content with consistent max-width and horizontal padding.

**Optional props**

- `max_width:` (`:sm | :md | :lg | :xl | :full`, default `:full`) — constrains content width. Values map to `max-w-2xl`, `max-w-4xl`, `max-w-6xl`, `max-w-7xl`, or no constraint.
- `padding:` (`:standard | :none`, default `:standard`) — adds responsive horizontal padding (`px-4 sm:px-6 lg:px-8`).

```erb
<%= ui_page(max_width: :lg) do %>
  <!-- page content -->
<% end %>
```

### `ui_section`

Groups related content with an optional header (title, subtitle, action) and vertical spacing.

**Optional props**

- `title:` (String) — section heading
- `subtitle:` (String) — secondary text below the title
- `action:` — slot for a trailing action (e.g. a button)
- `spacing:` (`:sm | :md | :lg`, default `:md`) — top margin between sections

```erb
<%= ui_section(title: "Products", subtitle: "All active items", spacing: :lg) do %>
  <!-- section content -->
<% end %>
```

### `ui_grid`

Renders a CSS grid with responsive column counts and configurable gap sizes.

**Optional props**

- `cols:` (Hash, default `{ default: 1 }`) — maps breakpoints to column counts (1-12). Keys: `:default`, `:sm`, `:md`, `:lg`.
- `gap:` (`:sm | :md | :lg | :xl`, default `:md`) — uniform gap size
- `gap_x:` (Symbol) — horizontal gap (overrides `gap:`)
- `gap_y:` (Symbol) — vertical gap (overrides `gap:`)

```erb
<%= ui_grid(cols: { default: 1, sm: 2, lg: 4 }, gap: :lg) do %>
  <!-- grid items -->
<% end %>
```

### `ui_panel`

Renders a bordered, rounded container with padding and optional shadow.

**Optional props**

- `padding:` (`:sm | :md | :lg`, default `:md`)
- `radius:` (`:md | :lg | :xl`, default `:lg`)
- `shadow:` (Boolean, default `true`)

```erb
<%= ui_panel(padding: :lg) do %>
  <!-- panel content -->
<% end %>
```

### `ui_card_link`

Renders a clickable card that wraps its content in an `<a>` tag with hover styling.

**Required props**

- `href:` (String or URL)

**Optional props**

- `padding:` (`:sm | :md | :lg`, default `:md`)
- `shadow:` (Boolean, default `true`)

```erb
<%= ui_card_link(href: product_path(@product)) do %>
  <h3>Product name</h3>
  <p>Product description</p>
<% end %>
```

### `ui_form`

Wraps content in a `<form>` tag with proper method handling. For non-GET/POST methods (patch, put, delete), it renders a hidden `_method` input following Rails conventions. Supports multipart for file uploads.

**Required props**

- `action:` (String) — form action URL

**Optional props**

- `method:` (`:get | :post | :patch | :put | :delete`, default `:post`) — HTTP method. Non-native methods use a hidden `_method` field.
- `multipart:` (Boolean, default `false`) — sets `enctype="multipart/form-data"` for file uploads
- `data:` (Hash) — data attributes for the form element

```erb
<%= ui_form(action: items_path, method: :post) do %>
  <%= ui_form_field(attribute: :name, required: true) %>
  <%= ui_button(label: "Save", type: :submit) %>
<% end %>

<%= ui_form(action: item_path(@item), method: :patch, multipart: true) do %>
  <%= ui_form_field(attribute: :name) %>
  <%= ui_file_upload(name: "item[photo]", accept: "image/*", hint: "Max 5MB") %>
  <%= ui_button(label: "Save", type: :submit) %>
<% end %>
```

### `ui_file_upload`

Renders a styled file upload area with a drop zone, label, and optional hint. The actual `<input type="file">` is visually hidden behind a styled click target.

**Required props**

- `name:` (String) — input name attribute

**Optional props**

- `label:` (String, default `"Choose file"`) — label text above the drop zone
- `accept:` (String) — accepted file types (e.g. `"image/*"`, `".pdf,.doc"`)
- `multiple:` (Boolean, default `false`) — allow multiple file selection
- `hint:` (String) — help text below the drop zone (e.g. file size limits)

```erb
<%= ui_file_upload(name: "avatar", accept: "image/*", hint: "PNG or JPG, max 5MB") %>
<%= ui_file_upload(name: "documents[]", multiple: true, label: "Upload documents", hint: "PDF, DOC up to 10MB each") %>
```

### `ui_form_field`

Wraps a label, input, hint, and error message in a consistent layout. Infers label text from the attribute name when not explicitly provided.

**Required props**

- `attribute:` (Symbol) — the form attribute name

**Optional props**

- `label:` (String) — explicit label text (inferred from `attribute:` if omitted)
- `type:` (`:text | :number | :email | :password | :textarea`, default `:text`)
- `required:` (Boolean, default `false`) — shows a red asterisk after the label
- `hint:` (String) — help text below the input
- `placeholder:` (String)
- `min:` / `max:` (for number inputs)

```erb
<%= ui_form_field(
  attribute: :name,
  label: "List Name",
  required: true,
  hint: "Enter a descriptive name"
) %>
```

### `ui_input`

Renders a standalone `<input>` element with consistent styling.

**Required props**

- `name:` (String)

**Optional props**

- `type:` (`:text | :number | :email | :password`, default `:text`)
- `value:` (String/Number)
- `placeholder:` (String)
- `disabled:` (Boolean, default `false`)
- `min:` / `max:` / `step:` (for number type)

```erb
<%= ui_input(name: "search", placeholder: "Search...") %>
<%= ui_input(name: "quantity", type: :number, value: 1, min: 1) %>
```

### `ui_textarea`

Renders a multi-line `<textarea>` element with consistent styling.

**Required props**

- `name:` (String)

**Optional props**

- `value:` (String)
- `rows:` (Integer, default `3`)
- `placeholder:` (String)
- `disabled:` (Boolean, default `false`)

```erb
<%= ui_textarea(name: "notes", rows: 5, placeholder: "Add notes...") %>
```

### `ui_page_header`

Renders a page title area with an optional subtitle and action slot. On small screens the title stacks above actions; on wider screens they sit side-by-side.

**Required props**

- `title:` (String) — the page heading

**Optional props**

- `subtitle:` (String) — secondary text below the title

**Block API** — register an action slot via `header.action`:

```erb
<%= ui_page_header(title: "Products", subtitle: "Manage your catalog") do |header| %>
  <% header.action do %>
    <%= ui_button(label: "New Product", href: new_product_path) %>
  <% end %>
<% end %>
```

### `ui_alert`

Renders a styled alert/flash message with type variants, optional title, and dismissible button.

**Required props**

- `message:` (String) — the alert message

**Optional props**

- `type:` (`:info | :success | :warning | :error`, default `:info`) — determines background/text color
- `title:` (String) — bold title above the message
- `dismissible:` (Boolean, default `false`) — shows a dismiss button when `true`

```erb
<%= ui_alert(message: "Changes saved successfully.", type: :success) %>
<%= ui_alert(message: "Could not save record.", type: :error, title: "Error", dismissible: true) %>
```

### `ui_select`

Renders a styled `<select>` dropdown.

**Required props**

- `name:` (String)

**Optional props**

- `options:` (Array of `[label, value]` pairs, default `[]`)
- `selected:` (String) — pre-selected value
- `include_blank:` (String) — blank option label
- `disabled:` (Boolean, default `false`)

```erb
<%= ui_select(
  name: "status",
  options: [["Active", "active"], ["Inactive", "inactive"]],
  selected: "active",
  include_blank: "Select status..."
) %>
```

### `ui_badge`

Renders an inline status badge.

**Required props**

- `label:` (String)

**Optional props**

- `variant:` (`:neutral | :success | :danger | :warning | :info`, default `:neutral`)

```erb
<%= ui_badge(label: "Active", variant: :success) %>
<%= ui_badge(label: "Expired", variant: :danger) %>
```

### `ui_stat_card`

Renders a metric card for dashboards.

**Required props**

- `label:` (String)
- `value:` (String/Number)

**Optional props**

- `variant:` (`:neutral | :success | :danger | :warning | :info`, default `:neutral`)
- `suffix:` (String) — unit label after the value

```erb
<%= ui_stat_card(label: "Revenue", value: "$42,300", variant: :success, suffix: "/mo") %>
```

### `ui_chart_card`

Renders a card wrapper for chart content with a title and configurable height.

**Required props**

- `title:` (String)

**Optional props**

- `height:` (`:sm | :md | :lg`, default `:md`) — maps to `h-48`, `h-64`, `h-96`

```erb
<%= ui_chart_card(title: "Monthly Revenue", height: :lg) do %>
  <!-- chart content -->
<% end %>
```

### `ui_copy_button`

Renders a button that copies text to the clipboard.

**Required props**

- `text:` (String) — the text to copy

**Optional props**

- `label:` (String, default `"Copy"`)
- `success_message:` (String, default `"Copied!"`)
- `error_message:` (String, default `"Failed!"`)

```erb
<%= ui_copy_button(text: "https://example.com/invite/abc123") %>
```

### `ui_modal`

Renders a modal dialog with title, close button, and backdrop.

**Required props**

- `title:` (String)

**Optional props**

- `size:` (`:sm | :md | :lg | :xl`, default `:md`)

```erb
<%= ui_modal(title: "Confirm Delete", size: :sm) do %>
  <p>This action cannot be undone.</p>
<% end %>
```

### `ui_accordion`

Renders collapsible question/answer items.

**Optional props**

- `items:` (Array of Hashes) — each with `:question` and `:answer` keys

```erb
<%= ui_accordion(items: [
  { question: "What is Keystone?", answer: "A UI component library for Rails." },
  { question: "How do I install it?", answer: "Add the gem and run the generator." }
]) %>
```

### `ui_tab_switcher`

Renders a tab bar with active state indicator. Uses Stimulus `tab-switcher` controller.

**Required props**

- `tabs:` (Array of Strings) — tab labels

```erb
<%= ui_tab_switcher(tabs: ["Overview", "Details", "History"]) do %>
  <!-- tab panel content -->
<% end %>
```

### `ui_option_card`

Renders a toggleable card option (radio-like selection).

**Required props**

- `name:` (String) — input name
- `value:` (String) — input value

**Optional props**

- `selected:` (Boolean, default `false`)
- `input_data:` (Hash) — data attributes for the hidden input
- `label_data:` (Hash) — data attributes for the label

```erb
<%= ui_option_card(name: "theme", value: "dark", selected: true) do %>
  Dark Mode
<% end %>
```

### `ui_hero`

Renders a large hero section for landing pages.

**Required props**

- `title:` (String)

**Optional props**

- `subtitle:` (String)
- `badge:` (String) — small badge text above the title
- `layout:` (`:split | :centered`, default `:split`)

```erb
<%= ui_hero(title: "Build faster with Keystone", subtitle: "UI components for Rails", badge: "New") do |hero| %>
  <% hero.with_aside do %>
    <!-- image or illustration -->
  <% end %>
<% end %>
```

### `ui_feature_grid`

Renders a grid of feature cards with icons.

**Required props**

- `title:` (String)
- `features:` (Array of Hashes) — each with `:icon`, `:title`, `:description`

**Optional props**

- `subtitle:` (String)

```erb
<%= ui_feature_grid(
  title: "Why Keystone?",
  subtitle: "Built for Rails developers",
  features: [
    { icon: "🚀", title: "Fast", description: "No build step required." },
    { icon: "🎨", title: "Themeable", description: "CSS custom properties." }
  ]
) %>
```

### `ui_cta_banner`

Renders a call-to-action banner with title, subtitle, and action buttons.

**Required props**

- `title:` (String)

**Optional props**

- `subtitle:` (String)

```erb
<%= ui_cta_banner(title: "Ready to get started?", subtitle: "Try Keystone today.") do %>
  <%= ui_button(label: "Get Started", href: signup_path) %>
<% end %>
```

### `ui_color_picker`

Renders an HSV color picker with swatch preview. Uses Stimulus `color-picker` controller.

**Required props**

- `name:` (String) — form input name

**Optional props**

- `value:` (String, default `"#000000"`) — initial hex color
- `label:` (String)

```erb
<%= ui_color_picker(name: "accent_color", value: "#3b82f6", label: "Accent") %>
```

### `ui_navbar`

Renders the top-level navigation bar with slots for desktop and mobile sections. Sticky by default.

**Optional props**

- `sticky:` (Boolean, default `true`)

**Slots:** `logo`, `desktop_links`, `desktop_right`, `mobile_left`, `mobile_center`, `mobile_right`

```erb
<%= ui_navbar do |nav| %>
  <% nav.with_logo do %>
    <%= link_to "MyApp", root_path %>
  <% end %>
  <% nav.with_desktop_links do %>
    <%= ui_nav_item(label: "Dashboard", href: root_path, active: true) %>
  <% end %>
<% end %>
```

### `ui_nav_item`

Renders a single nav link within the navbar.

**Required props**

- `label:` (String)
- `href:` (String)

**Optional props**

- `active:` (Boolean, default `false`)

```erb
<%= ui_nav_item(label: "Dashboard", href: "/", active: current_page?(root_path)) %>
```

### `ui_nav_dropdown`

Renders a dropdown menu within the navbar. Uses Stimulus `dropdown` controller.

**Required props**

- `title:` (String)
- `area:` (Symbol/String)

**Optional props**

- `active:` (Boolean, default `false`)

```erb
<%= ui_nav_dropdown(title: "Settings", area: :settings, active: false) do %>
  <%= link_to "Profile", profile_path %>
  <%= link_to "Billing", billing_path %>
<% end %>
```

### `ui_bottom_nav`

Renders a mobile bottom tab bar. Hidden on desktop (`lg:hidden`).

No props. Wrap `ui_bottom_nav_item` calls inside.

```erb
<%= ui_bottom_nav do %>
  <%= ui_bottom_nav_item(label: "Home", href: "/", icon: "<svg>…</svg>", active: true) %>
  <%= ui_bottom_nav_item(label: "Search", href: "/search", icon: "<svg>…</svg>") %>
<% end %>
```

### `ui_bottom_nav_item`

Renders a single bottom nav tab.

**Required props**

- `label:` (String)
- `href:` (String)
- `icon:` (String) — raw SVG string

**Optional props**

- `active:` (Boolean, default `false`)

```erb
<%= ui_bottom_nav_item(label: "Home", href: "/", icon: "<svg>…</svg>", active: true) %>
```

### `ui_mobile_header`

Renders a mobile header with back link, centered title, and optional subtitle. Hidden on `lg:` screens.

**Required props**

- `title:` (String)
- `back_url:` (String)

**Optional props**

- `subtitle:` (String)

```erb
<%= ui_mobile_header(title: "Edit Product", back_url: products_path) %>
```

### `ui_mobile_actions`

Renders an ellipsis dropdown for mobile action menus. Hidden on `lg:` screens. Uses Stimulus `dropdown` controller.

No props. Pass action links as block content.

```erb
<%= ui_mobile_actions do %>
  <%= link_to "Edit", edit_product_path(@product) %>
  <%= link_to "Delete", product_path(@product), data: { turbo_method: :delete } %>
<% end %>
```

### `ui_form_page`

Wraps a form page with title and back navigation. Sets `content_for` signals so the navbar can render mobile header context.

**Required props**

- `title:` (String)
- `back_url:` (String)

**Optional props**

- `subtitle:` (String)

```erb
<%= ui_form_page(title: "New Product", back_url: products_path) %>
```

### `ui_show_page`

Wraps a show/detail page with title and back navigation. Sets `content_for` signals so the navbar can render mobile header context.

**Required props**

- `title:` (String)
- `back_url:` (String)

**Optional props**

- `subtitle:` (String)

```erb
<%= ui_show_page(title: @product.name, back_url: products_path, subtitle: "Details") %>
```

### `ui_settings_link`

Renders a settings row link with label and chevron icon.

**Required props**

- `label:` (String)
- `href:` (String)

```erb
<%= ui_settings_link(label: "Account", href: account_settings_path) %>
```
