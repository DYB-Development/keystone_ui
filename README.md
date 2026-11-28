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
- It wires the Stimulus controllers by appending `registerControllers(application)` to `app/javascript/controllers/index.js`, so interactive components (accordion, modal, stat card info, …) work out of the box. If that file isn't present, the generator prints the one line to add manually.

At boot time, the engine initializer writes `keystone_source.css` with `@source` directives pointing to the gem's component files so Tailwind scans them automatically. The engine also adds the gem's controllers to your importmap automatically.

### How Tailwind integration works

- The generator commits only an `@import "./keystone_source.css"` line — no machine-specific paths in git.
- On every app boot (dev server, `assets:precompile`, CI), the engine writes
  `keystone_source.css` with `@source` and `@import` directives, including the
  stylesheet of [keystone_ui-styles](https://github.com/DYB-Development/keystone_ui-styles),
  which keystone_ui depends on.
- Tailwind's JIT scanner finds all component classes automatically.
- When keystone updates with new components, they're picked up on the next build
  with no action required.
- `keystone_source.css` is the only stylesheet a host imports for keystone_ui and the
  gems built on it. No keystone gem ships a Tailwind file that tailwindcss-rails
  turns into a generated stylesheet in `app/assets/builds/tailwind`.

### Registering a gem's Tailwind files

A gem built on keystone_ui adds its own CSS and the files Tailwind should scan in
an initializer, and `keystone_source.css` includes them:

```ruby
initializer "my_gem.tailwind" do
  KeystoneUi.configuration.tailwind_imports << root.join("app/assets/tailwind/my_gem.css").to_s
  KeystoneUi.configuration.tailwind_sources << root.join("app/views/**/*.erb").to_s
end
```

### Upgrading from older versions

Re-run the generator. It removes legacy `@import` and `@source inline(...)` lines
automatically:

```bash
rails generate keystone:install
```

## Light and dark mode

keystone_ui decides light and dark mode for the whole app, including the `dark:`
classes in your own views. The `html` element's `data-theme` attribute decides it:

```html
<html data-theme="dark">   <!-- always dark -->
<html data-theme="light">  <!-- always light -->
<html>                     <!-- follows the operating system -->
```

Do not declare your own `@custom-variant dark` in `application.css`. keystone_ui's
rule applies to your classes as well as keystone_ui's components.

### Letting users choose

Place the toggle anywhere in a view:

```erb
<%= ui_theme_toggle %>
```

It is one button showing a sun in light mode and a moon in dark mode. Pressing it
switches to the other mode at once and keeps that mode in a `keystone_theme`
cookie, and the server marks the `html` tag from that cookie so later pages open
in it. A visitor who has never pressed it sees the mode their device is set to,
and the button shows the sun or the moon to match. The install
generator adds the helper that does this to `app/views/layouts/application.html.erb`:

```erb
<html <%= keystone_theme_attributes %> lang="en">
```

Add it by hand if your layout lives elsewhere.

### Which mode a page gets

Strongest first:

1. The toggle's choice in this browser.
2. A mode supplied by another gem, such as a signed-in user's saved mode.
3. Light.

A gem supplies a mode by registering a callable that receives the view and returns
`"light"`, `"dark"`, `"system"`, `"custom"` or `nil`. A custom mode marks the page
`data-theme="custom"`:

```ruby
KeystoneUi.configure do |config|
  config.theme_mode_supplier = ->(view) { view.current_user&.theme_mode }
end
```

## Color System

Keystone UI components use two semantic color scales — **accent** and **surface** — defined as CSS custom properties. Components reference these via Tailwind classes like `bg-accent-500`, `text-accent-600`, `bg-surface-100`, etc. This means your entire UI updates when you change the color values — no need to touch component code.

### Defaults

keystone_ui-styles, which keystone_ui installs and imports for you, sets the default values:

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

### Usage in gems and engines

If you're building a gem or engine that uses `keystone_ui`, **do not set theme colors in your gem**. The host app owns the theme. Your gem just uses the accent/surface Tailwind classes and they'll inherit whatever the host app has configured.

**In your gem's `test/dummy` app**, set up colors the same way a host app would:

1. Add `keystone_ui` to your gemspec as a dependency
2. Run `rails generate keystone:install` in `test/dummy`
3. The default blue/zinc theme applies automatically — no extra config needed
4. To test with a custom theme, override the variables in `test/dummy/app/assets/tailwind/application.css`:

```css
@import "tailwindcss";
@import "./keystone_source.css";

@theme {
  --color-accent-500: #6366f1;
  /* ... */
}
```

**Key principle:** gems use `bg-accent-500`, `text-surface-700`, etc. in their views. The host app decides what those colors actually are — either statically in CSS, or dynamically with [`keystone_colors`](https://github.com/tylercschneider/keystone_colors) for per-user theming.

### Per-user theming

For dynamic, per-user color customization (e.g. letting users pick their own accent color), see the [`keystone_colors`](https://github.com/tylercschneider/keystone_colors) gem, which generates the CSS custom properties from user preferences at runtime.

## Looks

A look is one CSS file that changes how components look without editing the
gem. It sets the `--ks-` variables that keystone_ui-styles defines, and a
component reads them through the `ks-` classes it renders. Buttons, panels,
cards, alerts, badges, form fields, the modal, the mobile action menu, the column
picker, multi select, search select, copy button, theme toggle, checkbox row, radio card, option
card, file upload and colour picker read them today. So do the stat card, chart
card, card link, call to action banner, feature grid, hero, data table, code,
accordion, disclosure, tab switcher, progress, funnel, bucket, pipeline and swipe
deck, and the navbar title, nav items, nav dropdown, bottom nav, mobile header
and settings link.

### Writing a look file

This look changes the corner radius, font, label weight, border, padding and
colours of every button:

```css
/* app/assets/tailwind/look.css */
:root {
  --ks-radius-control: 9999px;
  --ks-font-body: "Roboto", sans-serif;
  --ks-font-weight-strong: 500;
  --ks-border-width-control: 1px;
  --ks-spacing: 0.3rem;

  --ks-color-accent: #6200ee;
  --ks-color-accent-hover: #7c4dff;
  --ks-color-neutral: #616161;
  --ks-color-neutral-hover: #757575;
  --ks-color-danger: #b00020;
  --ks-color-danger-hover: #c51162;
  --ks-color-on-fill: #ffffff;

  --ks-color-accent-dark: #bb86fc;
  --ks-color-accent-hover-dark: #d1b3ff;
  --ks-color-neutral-dark: #9e9e9e;
  --ks-color-neutral-hover-dark: #bdbdbd;
  --ks-color-danger-dark: #cf6679;
  --ks-color-danger-hover-dark: #e0879a;
  --ks-color-on-fill-dark: #000000;
}
```

Each colour variable has a `-dark` partner that a button reads on a dark page. A
look that sets only the light variable leaves dark pages with the default
colour. The keystone_ui-styles README lists every variable and its default.

### Where a look file goes

A host imports its look file after `keystone_source.css`:

```css
@import "tailwindcss";
@import "./keystone_source.css";
@import "./look.css";
```

keystone_ui-styles puts its defaults in Tailwind's base layer, and a `:root`
rule outside any layer overrides them. The look's `:root` rule must not sit
inside an `@layer` block.

### Shipping a look in a gem

A gem that ships a look registers its file in an initializer, and
`keystone_source.css` imports it after keystone_ui-styles:

```ruby
initializer "my_look.tailwind" do
  KeystoneUi.configuration.tailwind_imports << root.join("app/assets/tailwind/my_look.css").to_s
end
```

### Offering several looks

A host can offer several looks and let the page pick one. Each look file scopes
its variables to the look's name:

```css
/* app/assets/tailwind/looks/material.css */
:root[data-look="material"] {
  --ks-radius-control: 9999px;
  --ks-color-accent: #6200ee;
  --ks-color-accent-dark: #bb86fc;
}
```

Register each look by name with its file, and name the default:

```ruby
# config/initializers/keystone_ui.rb
KeystoneUi.configure do |config|
  config.register_look :plain, Rails.root.join("app/assets/tailwind/looks/plain.css")
  config.register_look :material, Rails.root.join("app/assets/tailwind/looks/material.css")
  config.default_look = :plain
end
```

`keystone_source.css` imports every registered look, and `keystone_theme_attributes`
marks the `html` tag with `data-look="plain"`. A gem can choose the look per
request by setting `config.look_supplier` to a lambda that receives the view and
returns a look's name. A name that is not registered leaves the page on the
default. A host that registers no looks gets no `data-look` attribute.
A Turbo visit carries the next page's look onto the page, as it does the theme.

Boot stops with `KeystoneUi::LookCheck::Error` when a registered look's file does
not exist, when the file sets no `--ks-` variables under
`:root[data-look="<name>"]`, or when `default_look` names a look that is not
registered, so a mistake shows up the moment the app starts.

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
- `class:` (String) — extra classes added to the component's outer element for this one use

### `ui_review_card`

Renders a card for one item someone reviews, such as one of several variants compared side by side. A header line shows a short id at the left and a score or status at the right, then come the title, the body text, an optional call-to-action line, an optional meta line of short details with a divider above it, an optional finding note in the warning style, and an optional row of buttons that each take an equal share of the row. When the card has a finding note, its edge is drawn in the warning style. From `sm` up its buttons are narrowed so three labels fit side by side in a third of the page, and below `sm` each button is at least 44px tall. The buttons are separated by a space in the card's text, so copied text and screen readers read each label as its own word.

**Required props**

- `id:` (String) — the short id at the left of the header line, such as `"variant A"`
- `title:` (String)

**Optional props**

- `score:` (String) — a score or status at the right of the header line
- `score_tone:` (`:muted`, or any `variant:` a badge takes: `:neutral | :success | :danger | :warning | :info`, default `:muted`) — the colour of the score
- `body:` (String) — the body text under the title
- `cta:` (String) — a call-to-action line under the body text, drawn in the link colour as text, not as a link
- `meta:` (String) — a line of short details, in a monospaced font, with a divider above it
- `finding:` (String) — a note drawn in the warning style, which also draws the card's edge in the warning style
- `actions:` (Array of Hashes) — `ui_button` keywords for each button, drawn as small secondary buttons
- `compact:` (Boolean, default `false`) — cuts the body text to one line with an ellipsis and leaves out the call-to-action line and the meta line, for a phone list

```erb
<%= ui_review_card_grid do %>
  <%= ui_review_card(
    id: "variant C",
    score: "reviewer 0.76 · 1 finding",
    score_tone: :warning,
    title: "Your fall wardrobe, finished.",
    body: "The pieces that pull the rest together. New this season, in the catalog now.",
    cta: "Open the catalog →",
    finding: %(Finding: "finished" implies completeness not in the brief (severity: low).),
    actions: [
      { label: "Apply fix", href: apply_fix_variant_path(@variant), method: :post },
      { label: "Edit", href: edit_variant_path(@variant) },
      { label: "Drop", href: variant_path(@variant), method: :delete }
    ]
  ) %>
<% end %>
```

### `ui_review_card_grid`

Sets the review cards passed in its block three across from `lg` up and one per row below it, with even gaps between them. It takes no props.

### `ui_button`

Renders a deterministic button or link. If `href` is present, an `<a>` tag is rendered.
Otherwise, a `<button>` tag is rendered with `type="button"`.

**Required props**

- `label:` (String)

**Optional props**

- `href:` (String or URL)
- `method:` (`:get | :post | :patch | :put | :delete`, default `:get`) — with `href:`, any method other than `:get` renders the button inside its own small form that sends that request when tapped
- `variant:` (`:primary | :secondary | :danger`, default `:primary`)
- `size:` (`:sm | :md | :lg`, default `:md`)
- `full_width:` (Boolean, default `false`) — makes the button, and the form of a button sending a request, as wide as its row
- `variant: :text` — draws the button as small, underlined, muted text instead of a button shape
- `name:` and `value:` (String) — a button with no `href:` submits them with its form when pressed
- `hidden:` (Boolean, default `false`) — draws the button with the `hidden` attribute, for a script to show later
- `confirm:` (String) — a question Turbo asks before following the link or sending the request; cancelling it sends nothing
- `disabled:` (Boolean, default `false`) — draws a button with no `href:` with the `disabled` attribute, so it cannot be pressed
- `formaction:` (String) — a button with no `href:` sends its form to this address in place of the form's own when pressed
- `params:` (Hash) — with `href:` and a method other than `:get`, each entry is sent with the request as a hidden field

```erb
<%= ui_button(label: "← Back", variant: :text, name: "back", value: "1") %>
```

```erb
<%= ui_button(label: "Start game", href: game_start_path(@game), method: :post, full_width: true) %>
```

```erb
<%= ui_button(label: "Use", href: offer_price_path(@offer), method: :patch, params: { "price[mode]" => "custom", "price[price]" => 2400 }) %>
```

### `ui_button_row`

Lays out the buttons passed in its block as one row with even gaps between them. When the row runs out of width, its buttons wrap onto a new line. On a phone each button is at least 44px tall. A button that sends a request is stretched across the form it sits in, so it takes its place in the row like any other button.

**Optional props**

- `equal_width:` (Boolean or `:phone`, default `false`) — `true` gives every button an equal share of the row's width and keeps each label on one line, so the row stays on one line until the labels no longer fit, and `:phone` does that below `sm` only, leaving each button the width of its label from `sm` up
- `class:` (String) — extra classes added to the row for this one use

```erb
<%= ui_button_row do %>
  <%= ui_button(label: "Add as fixture", variant: :secondary, size: :sm, href: fixtures_path(step: @step), method: :post) %>
  <%= ui_button(label: "Add label", variant: :secondary, size: :sm, href: new_step_label_path(@step)) %>
  <%= ui_button(label: "Re-run step", variant: :secondary, size: :sm, href: step_reruns_path(@step), method: :post) %>
  <%= ui_button(label: "View prompt", variant: :secondary, size: :sm, disabled: true) %>
<% end %>

<%= ui_button_row(equal_width: true) do %>
  <%= ui_button(label: "Apply fix", variant: :secondary, size: :sm, href: variant_fix_path(@variant), method: :post) %>
  <%= ui_button(label: "Edit", variant: :secondary, size: :sm, href: edit_variant_path(@variant)) %>
  <%= ui_button(label: "Drop", variant: :secondary, size: :sm, href: variant_path(@variant), method: :delete) %>
<% end %>
```

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
- `key:` (Symbol/String) — names the table so its saved layout can be found through `config.preference_supplier`
- `group_by:` (Symbol/String) — lists the rows under heading rows named by this key's value, one heading for each run of rows that share it
- `group_totals:` (Hash) — subtotals for each group, keyed by the group's name, each a hash of column key to value shown under that column in the group's heading row
- `total:` (Hash) — column key to value for a total row at the end of the table
- `current_row:` (item) — the item whose row is the viewer's own, given the `ks-table-row-current` class and `aria-current="true"`; only the first row equal to it is marked
- `phone_list:` (Boolean, default `false`) — `true` shows the table as a list below the `sm` breakpoint, one item per row with each cell under its column's heading; from `sm` up it is the same table
- `header:` (Boolean, default `true`) — `false` draws no heading row, and with `phone_list: true` no column heading label on any cell, subtotal or total, for a table of labels and their values
- `heading_caps:` (Boolean, default `false`) — draws each column heading in small capitals
- `density:` (Symbol, default `nil`) — `:compact` draws every heading and cell in extra small text with keystone_ui-styles' `ks-table-compact` padding of 10px on each side and 8px above and below, so a wide table such as a nine-column versions table fits an 805px panel with every value on one line

**Column options**

`Keystone::Ui::Column.new(key, header_text, mobile_hidden: false, sortable: false, hideable: false, locked: false, align: nil, wrap: false)`

| Option | Default | Description |
|--------|---------|-------------|
| `mobile_hidden:` | `false` | hide on small screens (`hidden sm:table-cell`) |
| `sortable:` | `false` | render header as clickable sort link |
| `hideable:` | `false` | allow hiding via `hidden_columns:` / column picker |
| `locked:` | `false` | on the first column, keep it in view while the rest of the table scrolls sideways; a locked column cannot be hidden or moved |
| `align:` | `nil` | `:start` aligns the heading and cells left, `:end` aligns them right; `nil` keeps the table's own alignment, which puts the last column right |
| `wrap:` | `false` | `true` lets long text in the column's cells wrap onto more lines inside the cell, where every other cell keeps its text on one line |

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

**Saved layouts**

Give a table a `key:` and it looks up its saved layout itself. The columns the call hides with `hidden_columns:` are the table's default layout, used whenever nothing is saved for the key.

```erb
<%= ui_data_table(
  items: @products,
  columns: columns,
  key: :products,
  hidden_columns: [ :sku ]
) %>
```

Set `config.preference_supplier` to a lambda that receives the view and the key and returns `{ value:, save_url: }`, or `nil` when the person can neither see nor save a layout. A gem that stores layouts, such as keystone_ui-preferences, sets it for the app. The table hides the hideable columns listed under `"hidden_columns"` in `value`, and keeps the columns its own call hides when `value` is `nil` or lists no `"hidden_columns"`. When nothing is saved yet, return `{ value: nil, save_url: }` so the person can save a first layout. When `save_url` is present, the table shows a "Columns" menu in a row above itself, aligned right, that saves to it. A table given no `key:`, or rendered with no supplier set, renders from its own call.

A saved `value` may also hold `"column_order"`, a list of hideable column keys. The table renders its hideable columns in that order, then any hideable columns the list leaves out in the order they were declared. Columns that are not hideable keep their declared place, and the Columns menu lists its columns in the order the table shows them.

```ruby
KeystoneUi.configure do |config|
  config.preference_supplier = ->(view, key) { TablePreferences.for(view.current_user, key) }
end
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

Pass a block to add a trailing "Actions" column. The block receives the component instance; call `actions` on it with a sub-block that receives each item. When the sub-block renders nothing for every row, the table draws no "Actions" column.

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
    <%= ui_action_menu_item(label: "Edit", href: edit_product_path(item)) %>
    <%= ui_action_menu_item(label: "Delete", href: product_path(item), method: :delete) %>
  <% end %>
<% end %>
```

**Current row**

Pass `current_row:` the item whose row belongs to the viewer, such as their own entry on a scoreboard. That row gets the `ks-table-row-current` class, which keystone_ui-styles colours, and `aria-current="true"`, so a screen reader announces it as the current row. The item is compared with `==`, and only the first equal row is marked.

```erb
<%= ui_data_table(
  items: @scores,
  columns: [ { team: "Team" }, { points: "Points" } ],
  current_row: @my_score
) %>
```

**Row colour**

In the block, `table.row_colour { |item| ... }` colours each row by what the block returns for its item: `:danger`, `:warning`, `:success` or `:info` tints every cell of the row in that colour, the same colours as the badge of the same name, and `nil` leaves the row plain. Any other value raises `KeyError`. Show the same meaning as text somewhere in the row, since a colour alone does not reach every reader.

```erb
<%= ui_data_table(items: @jobs, columns: [ { name: "Job" }, { status: "Status" } ]) do |table| %>
  <% table.row_colour { |job| :danger if job.failed? } %>
<% end %>
```

**Row detail**

In the block, `table.row_detail { |item| ... }` gives a row more to show than its columns. What the block returns for an item is drawn in a row under that item's row, in one cell across every column including the actions column, and hidden until the row is opened. A row whose block returns `nil` gets no detail and does not open. A row with detail starts its first cell with a caret button labelled "Show detail", carrying `aria-expanded` and `aria-controls`, so clicking the row, or pressing Enter or Space on the button, opens and closes it. Links, buttons and the action menu inside the row work without opening it. An open row stays open when a Turbo refresh morphs the page, and the detail row's id comes from the item's `id`, or its position when it has none, so the open row stays with its item when the rows change order. The `row-detail` Stimulus controller is registered by `registerControllers`.

```erb
<%= ui_data_table(items: @sessions, columns: [ { name: "Session" }, { status: "Status" } ]) do |table| %>
  <% table.row_detail { |session| render(SessionDetailComponent.new(session: session)) if session.running? } %>
<% end %>
```

**Phone list**

Pass `phone_list: true` to show a table as a list at phone width. Below `sm` the heading row is hidden, each row is one list item, and each of its cells sits on its own line under a `ks-caption` label holding its column's heading. Cells start at the left and wrap long text. A row's links, badges, detail button and action menu stay in its list item and work as they do in the table, and an open row's detail shows under its item. Each subtotal in a group heading row and each total after the first in the total row carries its column's heading too, while the group's name and the first total stand alone. Saved column layouts apply as they do to the table, so the labels follow the saved order and hidden columns are left out, and `mobile_hidden:` columns stay hidden. The sort links sit in the heading row, so a phone list cannot be sorted below `sm`. From `sm` up the table looks as it does without `phone_list:`, and a table that does not pass it looks the same at every width.

```erb
<%= ui_data_table(items: @quotes, columns: [ { name: "Quote" }, { status: "Status" }, { total: "Total" } ], phone_list: true) do |table| %>
  <% table.link(:name) { |quote| quote_path(quote) } %>
  <% table.actions { |quote| ui_action_menu_item(label: "Edit", href: edit_quote_path(quote)) } %>
<% end %>
```

**Labels and values**

Pass `header: false` to show a list of labels and their values as a table with no heading row. With `phone_list: true` each row then shows only its label and its value below `sm`, with no column heading label repeated on each line.

```erb
<%= ui_data_table(items: [ { field: "Product", detail: "Lawn mow" }, { field: "Sold", detail: "Nov 2, 2026" } ], columns: [ { field: "Field" }, { detail: "Detail" } ], header: false, phone_list: true) %>
```

Each row's actions show in an action menu, opened by an ellipsis button, so a table never shows buttons. When an actions column is present, position-based styling classes shift automatically — the last data column receives middle styling and the actions column receives last styling.

### `ui_column_picker`

Renders a "Columns" dropdown button with checkboxes for showing/hiding `hideable` columns. Pair with `ui_data_table`'s `hidden_columns:` param.

**Required props**

- `columns:` (Array of `Column` objects) — same array passed to `ui_data_table`

**Optional props**

- `hidden_columns:` (Array) — currently hidden column keys
- `save_url:` (String) — PATCH endpoint to persist preferences; omit for no persistence

Each column in the menu has an up and a down button that move it one place; the first column's up button and the last column's down button are disabled. Ticking, unticking and moving change only the open menu, and an unticked column's name turns grey straight away. When the menu closes, by a click outside it or on its Columns button, the Stimulus `column-picker` controller PATCHes `{ "hidden_columns": [...], "column_order": [...] }` as JSON to `save_url` once, then reloads via `Turbo.visit`. Closing it with nothing changed sends nothing. When the save is refused or cannot reach the server, the menu says "Your column changes were not saved.", puts its boxes and order back to what the table shows, and does not reload the page.

```erb
<%= ui_column_picker(
  columns: columns,
  hidden_columns: @hidden_columns,
  save_url: table_preferences_path("products")
) %>
```

### `ui_page`

Wraps page content with consistent max-width and horizontal padding. When the page also uses `ui_form_page` or `ui_show_page`, it shows their desktop back link or breadcrumbs, and the form page title, at its top.

**Optional props**

- `max_width:` (`:sm | :md | :lg | :xl | :full`, default `:full`) — constrains content width. Values map to `max-w-2xl`, `max-w-4xl`, `max-w-6xl`, `max-w-7xl`, or no constraint.
- `padding:` (`:standard | :none`, default `:standard`) — adds responsive horizontal padding (`px-4 sm:px-6 lg:px-8`).
- `class:` (String) — extra classes added to the component's outer element for this one use

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
- `menu:` — a list of `{ label:, href:, method: }` items shown in an action menu in the header, such as Edit and Delete
- `spacing:` (`:sm | :md | :lg`, default `:md`) — top margin between sections
- `class:` (String) — extra classes added to the component's outer element for this one use

**Slots**

- `aside` — short text, a badge or other markup, such as a legend, shown at the right end of the title line in small muted text, before the action and the menu. It needs a `title:`, and a section given an aside with no title raises `ArgumentError`. It never breaks in the middle of a word. From `sm` up it keeps its full width, and a title too long to fit beside it wraps onto more lines. On a phone it moves to its own line below the title and the actions.

```erb
<%= ui_section(title: "Products", subtitle: "All active items", spacing: :lg) do %>
  <!-- section content -->
<% end %>

<%= ui_section(title: "Inbox") do |section| %>
  <% section.with_aside { "sorted by expiry" } %>
  <!-- section content -->
<% end %>

<%= ui_section(title: "write_variant") do |section| %>
  <% section.with_aside { ui_badge(label: "succeeded", variant: :success) } %>
  <!-- section content -->
<% end %>
```

### `ui_grid`

Renders a CSS grid with responsive column counts and configurable gap sizes.

**Optional props**

- `cols:` (Hash, default `{ default: 1 }`) — maps breakpoints to column counts (1-12). Keys: `:default`, `:sm`, `:md`, `:lg`, `:xl`. Below the smallest breakpoint given, the columns stack into one.
- `wide:` (`:first | :second`) — at each breakpoint where `cols:` gives two columns, makes that column wider, taking three parts of the width to the other column's two
- `gap:` (`:sm | :md | :lg | :xl`, default `:md`) — uniform gap size
- `gap_x:` (Symbol) — horizontal gap (overrides `gap:`)
- `gap_y:` (Symbol) — vertical gap (overrides `gap:`)

```erb
<%= ui_grid(cols: { default: 1, sm: 2, lg: 4 }, gap: :lg) do %>
  <!-- grid items -->
<% end %>

<%= ui_grid(cols: { default: 1, xl: 2 }, wide: :first) do %>
  <!-- the wider panel, then the narrower one -->
<% end %>
```

### `ui_list_detail`

Lays out a list and the detail of the item picked from it. From `lg` up the list takes the first third of the width and the detail the other two thirds beside it. Below `lg` the detail is drawn above the list, so on a phone the picked item shows without scrolling past the list. With no detail, the list takes the full width at every size. The app writes no Tailwind classes to get either order.

Takes no props. The block is the list, and the `detail` slot is the picked item's detail. Leave the slot unset when nothing is picked.

```erb
<%= ui_list_detail do |layout| %>
  <% if @step %>
    <% layout.with_detail do %>
      <!-- the picked step -->
    <% end %>
  <% end %>
  <!-- the list of steps -->
<% end %>
```

### `ui_panel`

Renders a bordered, rounded container with padding and optional shadow.

**Optional props**

- `padding:` (`:sm | :md | :lg`, default `:md`)
- `radius:` (`:md | :lg | :xl`, default `:lg`)
- `shadow:` (Boolean, default `true`)
- `shaded:` (Boolean, default `false`) — fills the panel with a shaded background and leaves out its shadow, for a result box under a form
- `selected:` (Boolean, default `false`) — outlines the panel as the option in use
- `title:` (String) — a heading above the content
- `selected_marker:` (String) — written after the title, such as `"(in use)"`, only while the panel is `selected:`
- `aside:` (String) — a short note, such as an amount, at the right end of the title line

```erb
<%= ui_panel(padding: :lg) do %>
  <!-- panel content -->
<% end %>
```

```erb
<%= ui_panel(title: "Same value per dollar", aside: "$2,400", selected: @price_mode == "same", selected_marker: "(in use)") do %>
  <%= ui_caption(text: "The customer gets back the same multiple of price from us as from the market offer.", normal_case: true) %>
<% end %>

<%= ui_panel(shaded: true, shadow: false, padding: :sm) do %>
  <%= ui_value_list(align: :end, rows: [
    { label: "Value lines they know about", value: "$9,600", key: true },
    { label: "− Effort they expect", value: "$800" },
    { label: "Perceived value", value: "$8,800", key: true }
  ]) %>
  <%= ui_status_line(passed: true, text: "On what they believe, the customer gets back 2.9× the price, target 2×") %>
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
- `auto_submit:` (Boolean, default `false`) — sends the form, through `requestSubmit` so Turbo handles it, when a select, checkbox or radio button changes, and half a second after the person stops typing in a text or number field, or at once when they leave it. When Turbo morphs the page after the submit, the field the person is in keeps what they typed, and if the morph replaced that field, focus and the caret go back to it by its `id`. While a submission from the form is still being sent, a new change is held, and once that submission has finished and any Turbo Stream answer to it has been drawn, the held changes are sent as one submission with the form's values at that moment, so a hidden field the answer replaced, such as a `lock_version`, goes out with its new value. A submission that fails or never reaches the server releases the hold too. A `controller` or `action` already in `data:` is kept alongside it.

```erb
<%= ui_form(action: offer_path(@offer), method: :patch, auto_submit: true) do %>
  <%= ui_form_field(attribute: "price[market]", label: "What the market charges", type: :number, value: @offer.market_price, prefix: "$") %>
<% end %>
```

A form built with Rails' own form helpers gets the same behaviour from `data: { controller: "auto-submit", action: "change->auto-submit#changed input->auto-submit#typed turbo:submit-start->auto-submit#started turbo:submit-end->auto-submit#finished turbo:before-morph-attribute->auto-submit#keep turbo:before-render@document->auto-submit#remember turbo:render@document->auto-submit#restore" }`, and `data-auto-submit-delay-value` sets the wait after typing in milliseconds.

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

Renders a styled file upload with a clickable drop zone. Clicking anywhere on the zone opens the native file picker. Supports drag-and-drop — the zone highlights with accent colors on drag-over. Displays the selected file name(s) after pick or drop. Uses the `file-upload` Stimulus controller.

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

### `ui_search_select`

A form field that searches the host app as a person types and submits the id of the record they pick. It is one field of an ordinary form, not a separate form. Uses the `search-select` Stimulus controller.

As the person types, the field asks `url` for matches with `GET url?q=<typed text>` and an `Accept: application/json` header. The host answers with a JSON array of `{"id": ..., "label": ...}` objects, and the field lists their labels in the order given, as text. Picking one sets a hidden input named by `name:` to its id and shows its label in the field. The down and up arrow keys move the highlight, Enter picks the highlighted choice, and Escape closes the list.

**Required props**

- `name:` (String) — the name of the hidden input that submits the chosen id
- `label:` (String) — label text above the field
- `url:` (String) — where matches are fetched from

**Optional props**

- `selected_id:` / `selected_label:` — open the field with a record already chosen, so the form submits its id unchanged when nothing new is picked
- `new_label:` (String) — adds a last choice, such as "Enter a new address", that clears the chosen id and shows the block passed to the helper. The block is drawn hidden inside the field and holds the host's fields for the new record.

```erb
<%= ui_search_select(name: "space[address_id]", label: "Address", url: matches_addresses_path,
      selected_id: @space.address_id, selected_label: @space.address&.address, new_label: "Enter a new address") do %>
  <%= ui_form_field(attribute: "address[line1]", label: "Street") %>
<% end %>
```

### `ui_sortable_list`

A list whose rows can be dragged into a new order with a mouse or a finger. It is one field of an ordinary form and makes no request of its own, so nothing is saved until the form is submitted. Uses the `sortable-list` Stimulus controller, written with pointer events and no JavaScript dependency.

Each row holds a hidden field named by `name:` with the row's id, and dragging moves the field with the row, so the form submits the ids in the order shown. Give each list its own `name:` when a page has several, and each list orders only its own rows.

Dragging starts from the handle on the left of a row, so on a phone a finger on the rest of the row still scrolls the page. Each row also has Move up and Move down buttons, reachable by keyboard and named for screen readers, such as "Move Ann up". A status region announces the row's new position, such as "Ann is number 2 of 3.". A list longer than the screen does not scroll by itself during a drag.

Without JavaScript running, the rows show with no handle and no buttons, and the form submits the starting order.

Not tested in iPhone Safari or a Hotwire Native web view, only in Chrome with a mouse and emulated touch.

**Required props**

- `name:` (String) — the name of each hidden field, such as `"order[]"`
- `label:` (String) — the list's name for screen readers
- `rows:` (Array) — `{ id:, label: }` hashes in their starting order

```erb
<%= ui_form(action: tie_order_path, method: :patch) do %>
  <%= ui_sortable_list(name: "order[#{group.id}][]", label: "Tied for #{group.place}",
        rows: group.players.map { |player| { id: player.id, label: player.name } }) %>
  <%= ui_button(label: "Save") %>
<% end %>
```

### `ui_reading_hold`

Content with a button below it that stays unavailable until a set number of seconds has passed, until the end of the content has been in view, or both. Uses the `reading-hold` Stimulus controller. The hold is a courtesy in the browser, so the app using it checks the time and the end again on its server.

While the button is held it shows how long is left, or that the end has to be reached, and a press does nothing. The button stays reachable by keyboard and is described by that status for screen readers. A screen reader is told once when the button becomes available, not every second. Content whose end is already in view when the page loads counts as reached at once.

The form holding the button sends two fields, `<field_prefix>[end_reached]` and `<field_prefix>[end_in_view_on_load]`, each `"true"` or `"false"`. Going back to the page, through Turbo or the browser's back-forward cache, holds the button again.

Without JavaScript running, the button is available and the two fields are not sent.

Not tested in iPhone Safari or a Hotwire Native web view.

**Props**

- `seconds:` (Integer) — the seconds the button is held, default `0`
- `elapsed:` (Integer) — seconds already spent, such as since the server first showed the page, default `0`
- `require_end:` (Boolean) — hold the button until the end of the content has been in view, default `false`
- `waiting:` (String) — the status while seconds are left, with `{seconds}` replaced by the count
- `end_waiting:` (String) — the status once only the end is left
- `ready:` (String) — what a screen reader is told when the button becomes available
- `field_prefix:` (String) — the prefix of the two fields the form sends, default `"reading"`

Give the button `hold.button_options` so the hold can find it and describe it. A `ui_button` can take `data: { reading_hold_target: "button" }` instead, and the hold describes it by its status when it starts.

```erb
<%= ui_reading_hold(seconds: 30, elapsed: seconds_since_shown, require_end: true) do |hold| %>
  <% hold.with_action do %>
    <%= button_to "I Accept", accept_path, method: :patch, **hold.button_options %>
  <% end %>
  <%= render @document %>
<% end %>
```

### `ui_form_field`

Wraps a label, input, hint, and error message in a consistent layout. Infers label text from the attribute name when not explicitly provided.

**Required props**

- `attribute:` (Symbol) — the form attribute name

**Optional props**

- `label:` (String) — explicit label text (inferred from `attribute:` if omitted)
- `type:` (`:text | :number | :email | :password | :date | :datetime | :textarea`, default `:text`) — `:datetime` renders a `datetime-local` input, and a `Time` or `DateTime` given as `value:` is written as `YYYY-MM-DDTHH:MM`
- `required:` (Boolean, default `false`) — shows a red asterisk after the label, on an input sets the `required` attribute so the form will not send while it is empty, and on a `:checkbox` sets it so the form will not send while the box is unticked
- `hint:` (String) — help text below the input
- `placeholder:` (String)
- `min:` / `max:` (for number inputs)
- `disabled:` (Boolean, default `false`) — shows the value in an input that cannot be typed into and is not submitted
- `autofocus:` (Boolean, default `false`) — puts the cursor in the input when the page opens
- `autocomplete:` / `autocapitalize:` / `inputmode:` (String) — written onto the input as given, such as `"email"`, `"none"` and `"numeric"`
- `prefix:` / `suffix:` (String) — for a text or number input, short text such as `"$"`, `"hours"` or `"%"` drawn inside the field's border before or after the input
- `options:` (Array, default `[]`) — for `type: :select`, the choices as `[label, value]` pairs, and a choice given as `[label, value, { disabled: true }]` is drawn greyed out and cannot be chosen
- `include_blank:` (String or `false`) — for `type: :select`, the words of the empty first choice a select that is not required starts with, blank by default, and `false` leaves the empty choice out without making the field required or showing the asterisk

The label is tied to its input, textarea, select or checkbox through an `id` built from `attribute:`, so `"player[email]"` gets the id `player-email`.

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

- `type:` (`:text | :number | :email | :password | :date | :datetime`, default `:text`) — `:datetime` renders a `datetime-local` input, and a `Time` or `DateTime` given as `value:` is written as `YYYY-MM-DDTHH:MM`
- `value:` (String/Number)
- `placeholder:` (String)
- `disabled:` (Boolean, default `false`)
- `min:` / `max:` / `step:` (for number type)
- `autofocus:` / `required:` (Boolean, default `false`)
- `autocomplete:` / `autocapitalize:` / `inputmode:` (String) — written onto the input as given
- `prefix:` / `suffix:` (String) — short text drawn inside the input's border before or after it

```erb
<%= ui_input(name: "search", placeholder: "Search...") %>
<%= ui_input(name: "quantity", type: :number, value: 1, min: 1) %>
<%= ui_input(name: "price[market]", type: :number, value: 3000, prefix: "$") %>
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

Renders a page title area with an optional subtitle, badges, action slot and action menu. From `sm` screens up the title and its badges sit on the left and the actions and menu on the right, side by side in one row whether or not there is a menu. Below `sm` a header given no badges and no menu is hidden, even when it has an action. A header given badges or a menu is shown below `sm` with its badges, actions and menu, and its title is hidden there when the page holds `ui_mobile_header`'s title, so the title is not shown twice. Below `sm` its actions and menu sit side by side on their own full-width row under the title and badges. At every width the actions row is never wider than the header, and buttons that do not fit wrap onto another line, so the header never makes the page wider than the screen.

**Required props**

- `title:` (String) — the page heading

**Optional props**

- `subtitle:` (String) — secondary text below the title
- `subtitle_mono:` (Boolean, default `false`) — draws the subtitle in a fixed-width font, such as a run's id and start time
- `action_url:` (String) — the address of the screen's main action. It is drawn as a button when no `header.action` block is given, and published for `ui_mobile_action` either way
- `action_label:` (String, default `"Add new"`) — the name of the main action
- `action_method:` (Symbol) — the method the main action sends, such as `:post`. With a method other than `:get` the button is a form that sends it to `action_url:`, and the method is published for `ui_mobile_action` as `content_for(:mobile_action_method)`. Without it the button is a link and no method is published
- `action_confirm:` (String) — a question asked before the main action is sent, on the header's button, on `ui_bottom_action` and on `ui_mobile_action`'s icon when `action_method:` is given, which both read it from `content_for(:mobile_action_confirm)`
- `action_at_bottom:` (Boolean, default `false`) — the main action belongs at the bottom of a phone screen, so the header hides its own action below `sm` and shows it as before from `sm` up
- `badges:` (Array, default `[]`) — `[{ label:, variant: }, ...]`, each drawn as a `ui_badge` beside the title, where `variant:` is the badge's colour (`:neutral | :success | :danger | :warning | :info`, default `:neutral`)
- `menu:` (Array, default `[]`) — `[{ label:, href:, method:, confirm: }, ...]`, each hash taking the keywords of `ui_action_menu_item`, drawn in a `ui_action_menu` beside the actions
- `class:` (String) — extra classes added to the component's outer element for this one use

```erb
<%= ui_page_header(title: "Products", action_url: new_product_path, action_label: "New Product") %>
<%= ui_page_header(title: run.flow_name, subtitle: "#{run.code} · started #{run.started_at.strftime("%H:%M:%S")}", subtitle_mono: true) %>
```

```erb
<%= ui_page_header(title: "Order 1042", action_url: edit_order_path(order), action_label: "Edit",
                   badges: [{ label: "Paid", variant: :success }],
                   menu: [{ label: "Delete", href: order_path(order), method: :delete }]) %>
```

**Block API** — register an action slot via `header.action`, which is drawn alone when `action_url:` is also given:

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
- `class:` (String) — extra classes added to the component's outer element for this one use

```erb
<%= ui_alert(message: "Changes saved successfully.", type: :success) %>
<%= ui_alert(message: "Could not save record.", type: :error, title: "Error", dismissible: true) %>
```

### `ui_empty_state`

Shows what a list or section holds when it has nothing in it, centred, with a heading, an optional message and an optional action.

**Required props**

- `title:` (String) — the heading, such as "No reports yet"

**Optional props**

- `message:` (String) — muted text under the title saying when something will appear
- `action:` (Hash) — `{ label:, href: }`, drawn as a secondary button linking to `href`

```erb
<%= ui_empty_state(title: "No reports yet", message: "Reports appear here once the team shares one.") %>
<%= ui_empty_state(title: "No forms started", action: { label: "Start", href: new_form_path }) %>
```

### `ui_link_list`

A list of links, one row per item, each row ending in a chevron. Use it where each item opens its own page and a table would be too wide, such as on a phone.

**Required props**

- `rows:` (Array) — hashes with `label:` and `href:`, in the order shown

**Optional keys on a row**

- `subtitle:` (String) — a short note under the label
- `badge:` (Hash) — `{ label:, variant: }`, drawn with `ui_badge`, above the label below `sm` and beside it from `sm` up
- `value:` (String) — a short value after the label, such as a count or a date
- `top_line:` (Hash) — `{ badge:, text: }`, a line above the label with `badge:` (`{ label:, variant: }`, drawn with `ui_badge`, apart from the row's `badge:`) at the left and `text:` at the right. In place of `badge:` it takes `type:` (`{ label:, tone: }`), which shows the row's type as small-capital text in the tone's colour, such as `{ label: "Approval", tone: :warning }`. It stays on one line, and a long `text:` is cut off with an ellipsis. A long badge wraps onto more lines, and `text:` keeps its full width beside it
- `current:` (Boolean) — marks the row as the current one with `aria-current="true"` and keystone_ui-styles' `ks-value-list-row-current` class, which tints the row and draws an accent bar at its left

**Optional props**

- `chevron:` (Boolean, default `true`) — `false` leaves off every row's chevron
- `new_tab:` (Boolean, default `false`) — `true` opens every row's link in a new browser tab with `target="_blank"` and `rel="noopener"`, so the page it was followed from stays open

```erb
<%= ui_link_list(rows: @reports.map { |report|
      { label: report.kind, subtitle: report.period, href: report_path(report),
        badge: (report.invoice? ? { label: "Invoice", variant: :info } : nil) } }) %>
```

A queue of items, each with its type and time left above its title, the open one marked:

```erb
<%= ui_link_list(chevron: false, rows: @items.map { |item|
      { label: item.title, subtitle: item.details, href: item_path(item),
        top_line: { badge: { label: item.item_type, variant: :warning }, text: "expires #{item.time_left}" },
        current: item == @item } }) %>
```

Documents linked beside a form, opened in a new tab so the form keeps what was typed:

```erb
<%= ui_link_list(new_tab: true, rows: [
      { label: "Terms of Service", href: terms_path },
      { label: "Privacy Policy", href: privacy_path }
    ]) %>
```

### `ui_action_list`

Shows rows that are each a sentence, with an optional small button at the right of the sentence. On a phone the button sits under its sentence.

**Required props**

- `rows:` (Array of Hashes) — each is `{ text: }`, with optional `button:`, the keywords of a `ui_button`. The button is small and secondary unless `button:` says otherwise. With `href:` and a method such as `:post` it sends its own request, with `params:` as hidden fields, and with `name:` and `value:` and no `href:` it submits the form around the list.

```erb
<%= ui_action_list(rows: [
  { text: "Lower the price from $3,000 to $2,400.", button: { label: "Use", href: offer_price_path(@offer), method: :patch, params: { "price[price]" => 2400 } } },
  { text: "Or raise actual value by $1,200 at the current price." }
]) %>
```

### `ui_select`

Renders a styled `<select>` dropdown.

**Required props**

- `name:` (String)

**Optional props**

- `options:` (Array of `[label, value]` pairs, default `[]`) — a choice given as `[label, value, { disabled: true }]` is drawn greyed out and cannot be chosen
- `selected:` (String) — pre-selected value
- `include_blank:` (String) — blank option label, and with none given the select has no empty choice
- `disabled:` (Boolean, default `false`)

```erb
<%= ui_select(
  name: "status",
  options: [["Active", "active"], ["Inactive", "inactive"]],
  selected: "active",
  include_blank: "Select status..."
) %>

<%= ui_form_field(
  attribute: "offer[plan]",
  type: :select,
  include_blank: false,
  options: [["Monthly", "monthly"], ["Yearly", "yearly", { disabled: true }]]
) %>
```

### `ui_badge`

Renders an inline status badge. Its five variants are the five states `ui_status_dot` accepts, read from one list, `Keystone::Ui::States::NAMES`, so a state either has both or has neither.

**Required props**

- `label:` (String)

**Optional props**

- `variant:` (`:neutral | :success | :danger | :warning | :info`, default `:neutral`)
- `class:` (String) — extra classes added to the component's outer element for this one use

```erb
<%= ui_badge(label: "Active", variant: :success) %>
<%= ui_badge(label: "Expired", variant: :danger) %>
```

### `ui_status_dot`

Draws a small round dot showing an item's state, in the same colour as a badge of that state, such as in a list of runs or steps. Its label is read by screen readers and not shown on screen. A state outside the five raises an `ArgumentError` naming it, so a host maps its own states, such as queued or running, onto the five itself. The five are read from `Keystone::Ui::States::NAMES`, the same list the badge's variants are read from. It needs keystone_ui-styles 0.34.0 or later.

**Required props**

- `state:` (`:neutral | :success | :danger | :warning | :info`)
- `label:` (String) — what the state means, for screen readers

```erb
<%= ui_status_dot(state: :success, label: "Passed") %>
```

### `ui_status_line`

Draws a sentence after a small round icon: a green check for a pass and a red cross for a fail. The icon is labelled "Pass" or "Fail" for screen readers, so the result is never told by colour alone. Given `passed: nil` it draws the sentence alone, with no icon and no space left for one, for a line of information shown among pass and fail lines.

**Required props**

- `passed:` (`true | false | nil`) — `nil` draws no icon
- `text:` (String) — the sentence

```erb
<%= ui_status_line(passed: nil, text: "Gross margin 62%") %>
<%= ui_status_line(passed: @offer.scale_check_passed?, text: "Lifetime gross profit is 2.4× CAC and lifetime COGS, target 2×") %>
```

### `ui_figure`

Shows a figure, such as an amount or a step's result, in plain text or in the success, danger, warning or info colour.

**Required props**

- `text:` (String)

**Optional props**

- `tone:` (`:neutral | :success | :danger | :warning | :info`, default `:neutral`)

```erb
<%= ui_figure(text: "$4,700.00", tone: :success) %>
<%= ui_figure(text: "-$300.00", tone: :danger) %>
<%= ui_figure(text: "Waiting", tone: :warning) %>
```

### `ui_chip_row`

Shows a row of summary chips. Each chip draws its label and value in its tone's colour on a tinted background. The chips share the row's width equally, and on a phone they sit three across, with a fourth starting a new line.

**Required props**

- `chips:` (Array of Hashes) — each chip is `{ label:, value:, tone: }`, where `tone:` is `:neutral`, `:success`, `:danger`, `:warning` or `:info`, with optional `mono: true` to draw the value in a fixed-width font

```erb
<%= ui_chip_row(chips: [
  { label: "Checks", value: "4/4", tone: :success },
  { label: "Reviewer", value: "0.88", tone: :success },
  { label: "p", value: "0.84", tone: :neutral, mono: true }
]) %>
```

### `ui_picture`

Shows an image, centred and never taller than half the visible screen, so what follows it stays in view on a phone.

**Required props**

- `src:` (String) — the address of the image to show
- `alt:` (String) — the text read out in place of the image

**Optional props**

- `full_size_url:` (String) — when given, tapping the picture opens this address in a new tab

```erb
<%= ui_picture(src: url_for(question.picture.variant(:display)), alt: question.text, full_size_url: url_for(question.picture)) %>
```

### `ui_heading`

Shows a heading at one of three sizes, with an optional short note at the right end of its row.

**Required props**

- `text:` (String)

**Optional props**

- `size:` (`:sm | :md | :lg`, default `:md`)
- `note:` (String) — a short note in muted text at the right end of the heading's row

```erb
<%= ui_heading(text: "Work", note: "12.5 billable hours") %>
<%= ui_heading(text: "Monthly report", size: :lg) %>
```

### `ui_caption`

Shows small, uppercase, muted text for placing above a title or a figure.

**Optional props**

- `text:` (String) — the caption's text, left out when the caption is given a block
- `tone:` (`:muted | :link`, default `:muted`) — `:link` draws the caption in the link colour with space under it, as the label above a quiz question
- `normal_case:` (Boolean, default `false`) — draws a small muted line in the case it was written, in the normal weight, with any links in it in the link colour, such as a note under a step's details

A block given to the caption is shown in place of `text:`, so the line can hold links.

```erb
<%= ui_caption(text: "Work report") %>
<%= ui_caption(text: "Geography", tone: :link) %>
<%= ui_caption(normal_case: true) do %>
  <%= link_to request.code, request_path(request) %> · <%= link_to run.code, run_path(run) %>
<% end %>
```

### `ui_paragraph`

Shows a paragraph of running text.

**Required props**

- `text:` (String)

```erb
<%= ui_paragraph(text: "Work from 1 to 30 September.") %>
```

### `ui_link`

Draws a text link in the link colour.

**Required props**

- `label:` (String)
- `href:` (String or URL)

**Optional props**

- `centred:` (Boolean, default `false`) — draws the link on its own line with its label in the middle

```erb
<%= ui_link(label: "Upload questions", href: upload_questions_path) %>
<%= ui_link(label: "Finish on desktop", href: run_path(run), centred: true) %>
```

### `ui_facts`

Draws a wrapping row of facts, each a count in bold beside its label, such as the number of questions on a quiz's intro page.

**Required props**

- `facts:` (Array of Hashes) — each fact is `{ value:, label: }`

```erb
<%= ui_facts(facts: [ { value: 12, label: "questions" } ]) %>
```

### `ui_value_list`

Shows rows of a label and its value, such as a ledger, a byline beside a title, or a list of terms and what they mean.

**Required props**

- `rows:` (Array of Hashes) — each row is `{ label:, value: }`, with optional `note:` (a short note under the label), `total: true` (draws the row with more weight), `key: true` (draws the row larger than the others, for a key figure that is not a total), `right: true` (draws a green check mark, read out as "Right", after the value) and `fallback:` (shown when the value is `nil` or empty)

**Optional props**

- `align:` (`:start | :end`, default `:start`) — `:start` places each value beside its label, `:end` pushes it to the right end of its row
- `columns:` (Boolean, default `false`) — shows each label in small text with its value directly below it, and lays the pairs in one column on a phone and two columns from `sm` up, with a long value wrapping inside its own column
- `label_caps:` (Boolean, default `false`) — draws each label in small capitals
- `value_mono:` (Boolean, default `false`) — draws each value in a fixed-width font

```erb
<%= ui_value_list(align: :end, rows: [
  { label: "Rate", value: "$150.00", note: "per hour" },
  { label: "Billable hours", value: "12.5" },
  { label: "Reviews", value: nil, fallback: "N/A" },
  { label: "Total billed", value: "$1,875.00", total: true }
]) %>
```

```erb
<%= ui_value_list(columns: true, rows: [
  { label: "Agent", value: "copy_writer v22" },
  { label: "Model", value: "claude-sonnet" },
  { label: "Tokens / cost", value: "4,120 in · 310 out · $0.11" },
  { label: "Format", value: "copy_block v3" }
]) %>
```

### `ui_stacked_bar`

Draws one horizontal bar 28 pixels tall split into segments, each as wide as its share of the bar, with a 2 pixel gap between them, and a legend under it of every segment's colour, name and amount. Each segment prints its amount inside it when the segment is wide enough to hold it. Hovering over a segment, tapping it or reaching it with the keyboard shows a tooltip of its name, its amount and its share of the total, and a screen reader hears the same three. A segment whose amount is zero or negative is not drawn and is still listed in the legend.

**Required props**

- `segments:` (Array of Hashes) — each is `{ label:, amount:, tone: }`, with optional `value:` (the amount as it is shown, such as `"$1,800"`, the amount itself when left out) and `size:` (the width to draw the segment at in place of its amount). `tone:` is one of the fill tones below, and any other raises `ArgumentError` naming it.

**Optional props**

- `total:` (Number) — the total each share is worked out against, the sum of the drawn amounts when left out. A total of zero shows no share.
- `total_label:` (String, default `"the total"`) — what the total is called, as in "40% of actual value"

The fill tones, each with a light and a dark colour, are `:teal` (#00b894 / #00a888), `:orange` (#f47230 / #e76624), `:blue` (#257de0 / #338ced) and `:amber` (#f2a600 / #d28e05), listed in `Keystone::Ui::Fills::CLASSES`.

```erb
<%= ui_stacked_bar(total: @offer.actual_value, total_label: "actual value", segments: [
  { label: "Customer net value", amount: @offer.net_value, value: number_to_currency(@offer.net_value, precision: 0), size: @offer.net_value_drawn, tone: :teal },
  { label: "Our gross profit", amount: @offer.gross_profit, value: number_to_currency(@offer.gross_profit, precision: 0), tone: :orange },
  { label: "COGS", amount: @offer.cogs, value: number_to_currency(@offer.cogs, precision: 0), tone: :blue }
]) %>
```

### `ui_progress`

Draws a bar filled to `value` out of `max`, never past full, with an optional caption above it.

**Required props**

- `value:` / `max:` (Number)

**Optional props**

- `label:` (String) — a caption above the bar
- `thin:` (Boolean, default `false`) — draws the bar 4 pixels tall, as a share meter under a row
- `tone:` (one of the `ui_stacked_bar` fill tones) — fills the bar with that tone's colour

```erb
<%= ui_progress(value: line.amount, max: @offer.ceiling, thin: true, tone: :teal) %>
```

### `ui_bar_chart`

Draws a bar chart on the server as an SVG, so it shows with no JavaScript and prints as it shows on screen. The value axis is labelled in round steps reaching just past the largest value, with a grid line at each step. The bars stretch to fill the chart's width, the chart grows no taller than it is in an 800px-wide column, and its labels stay at the page's small text size at any width.

**Required props**

- `bars:` (Array of Hashes) — each bar is `{ label:, value: }`, where a negative `value:` raises `ArgumentError` naming it, with optional `shaded: true` to draw it faded, such as a weekend day, and optional `group:` to put it in a group, such as the version that produced it

**Optional props**

- `show_values:` (Boolean, default `false`) — write each bar's value on it
- `strip:` (Boolean, default `false`) — draw the chart as a short strip 114px tall, with no value axis and no grid lines, only a baseline under the bars, and the bars nearly touching

```erb
<%= ui_bar_chart(show_values: true, bars: [
  { label: "Fri", value: "2.5" },
  { label: "Sat", value: "0.5", shaded: true }
]) %>
```

Bars given `group:` are grouped by its value, with the groups taken as oldest to newest in the order they first appear. Every bar in a group is drawn in the same tone, and the tones run from grey for the oldest group to the accent for the newest, with no two groups sharing a tone. With more than five groups the newest four keep their own tones and every older group is drawn in grey. Only the first bar of each group has its label written under the axis, starting at that bar's left edge, so give the other bars of a group an empty label. The newest group's label ends at the chart's right edge instead, so a phone never cuts it off. The group tones come from keystone_ui-styles 0.38.0 or later.

```erb
<%= ui_bar_chart(strip: true, bars: [
  { label: "v19 → 0.77", value: 0.58, group: "v19" },
  { label: "", value: 0.63, group: "v19" },
  { label: "v21 → 0.80", value: 0.66, group: "v21" },
  { label: "", value: 0.72, group: "v21" },
  { label: "v22 → 0.84", value: 0.76, group: "v22" },
  { label: "", value: 0.84, group: "v22" }
]) %>
```

### `ui_timeline`

Draws one row per label, in the order each label first appears. Entries that share a label, such as the tries of one step, are drawn on the same row, one bar each. Every bar is placed by its entry's start and end on one axis shared by every row, and a bar shorter than 2% of the axis is drawn 2% wide so it stays visible. The axis runs from the earliest queued or start time to the latest end or start, and shows `0s` at its left and the total duration at its right. Each row shows its label and the sum of the time each of its entries took, leaving out the gaps between them, written with one decimal under ten seconds, such as `0.3s` or `8.2s`, and otherwise from the largest unit that is not zero, such as `42s`, `3m 5s` or `1h 0m 5s`. A row of more than one entry adds its number of attempts after that time, such as `41s · 2 att.`. An entry given `queued_at:` has the time from then to its start drawn before its bar in the queued colour. An entry given `failed: true` is drawn in the danger colour, and screen readers read it as failed. An entry given `href:` draws its bar as a link to that address, which screen readers read by its row's label, and a row's label links to the address of the row's last entry that has one. An entry given `selected: true` draws its row in the current row tint the data table's `current_row:` uses, with `aria-current="true"`, so screen readers announce it as the current item. Entries given neither draw no links and no tint. An entry given `ended_at: nil` is still running: its bar is drawn up to the latest time on the axis, and its row shows an info status dot that screen readers read as running. An entry given `waiting: true` is paused, such as a step waiting for approval: its bar is drawn from its start to the end of the axis in the waiting colour, and its row shows `waiting` in the warning tone where its time would be, with no running dot. To draw the axis up to the present, give a waiting entry `ended_at: Time.current`. An entry with no `started_at:`, whose `ended_at:` is before its `started_at:`, or whose `queued_at:` is after its `started_at:`, raises `ArgumentError` naming the entry's label. Given no entries, the timeline shows an empty state titled `No steps`. The track and bars are drawn in the timeline's own colours, set by keystone_ui-styles 0.35.0 or later.

Given `one_line: true`, each row shows its label, then its bar, then its duration on one line from `sm` up. The timeline is one grid, so every row's bar sits in one column of the same width, and the label column grows to the longest label up to 40% of the timeline's width, cutting a longer label short. Above the first row, in the bar column, marks along the axis are placed at even intervals from `0s`, at the smallest step from 1 second up to 1 day that covers the run in six intervals or fewer, such as `0s`, `1m`, `2m` up to `6m`. The axis then ends at the last mark rather than at the latest time, and each mark sits at its time on the same axis the bars use. Below `sm` it falls back to the default layout: each row shows its full label, wrapped onto more lines when long, and its duration above its bar, and the marks give way to `0s` at the left and the axis's last mark at the right under the rows.

**Required props**

- `entries:` (Array of Hashes) — each entry is `{ label:, started_at:, ended_at: }`, with the times as `Time` values and `ended_at:` `nil` for an entry still running, and may add `queued_at:`, `failed: true`, `waiting: true`, `href:` and `selected: true`

**Optional props**

- `one_line:` (Boolean) — draws each row's label, bar and duration on one line with marks along the axis, `false` by default
- `text_mono:` (Boolean) — draws each step name and duration in a fixed-width font, and wraps a long step name inside its row so a phone page does not scroll sideways, `false` by default

```erb
<%= ui_timeline(entries: [
  { label: "Plan", started_at: plan.started_at, ended_at: plan.ended_at },
  { label: "Build", queued_at: first_try.queued_at, started_at: first_try.started_at, ended_at: first_try.ended_at, failed: true },
  { label: "Build", started_at: second_try.started_at, ended_at: second_try.ended_at, href: step_path(second_try), selected: true },
  { label: "Approve", started_at: approval.started_at, ended_at: Time.current, waiting: true }
]) %>
```

```erb
<%= ui_timeline(entries: steps, one_line: true) %>
```

### `ui_text_diff`

Shows two versions of a text side by side, such as two versions of an agent's prompt, the first on the left and the second on the right. Lines the two share sit on the same row in both columns. A line only the first version has is marked as removed on the left, in red, with a minus sign, and a line the second version adds is marked as added on the right, in green, with a plus sign, with a blank cell opposite each. Each column numbers the lines of its own version. Below `sm` the two versions are stacked, the first above the second. It is drawn in the code block's look, and needs keystone_ui-styles 0.34.0 or later for the removed and added colours.

**Required props**

- `before:` (String) — the first version
- `after:` (String) — the second version

**Optional props**

- `one_column:` (Boolean, default `false`) — shows both versions in one column, the same at every screen width, in place of side by side. Lines the two share appear once with no sign. A removed line appears at its place in the first version, coloured as removed and starting with a minus, and an added line appears at its place in the second, coloured as added and starting with a plus. The colour covers the sign and the text of the line. The column numbers no lines, and a long line scrolls sideways inside the column rather than widening the page. When the texts are too long to compare, the column shows every line of the first version and then every line of the second, with no line marked.

```erb
<%= ui_text_diff(before: previous_version.instructions, after: version.instructions) %>
```

```erb
<%= ui_text_diff(before: previous_version.instructions, after: version.instructions, one_column: true) %>
```

Windows and Unix line endings compare as equal. Two identical texts show a notice above the text saying they are the same. When the two texts together run past 2,000 lines, the diff does not compare them: it shows both versions line by line with no line marked, under a notice saying they are too long to compare. A host changes that limit for the whole app in an initializer:

```ruby
KeystoneUi.configure do |config|
  config.text_diff_line_limit = 5000
end
```

### `ui_stat_card`

Renders a metric card for dashboards.

**Required props**

- `label:` (String)
- `value:` (String/Number)

**Optional props**

- `variant:` (`:neutral | :success | :danger | :warning | :info`, default `:neutral`)
- `suffix:` (String) — unit label after the value
- `definition:` (String) — what the metric captures
- `calculation:` (String) — how the metric is computed
- `change:` (Number) — percent change against the previous period, shown as ▲/▼
- `href:` (String) — turns the value into a link to that URL; the card itself stays unlinked
- `note:` (String) — a short note shown under the value
- `plain:` (Boolean, default `false`) — draws a plain figure with no card border or background, for a row of figures
- `fallback:` (String) — shown in a muted colour when the value is missing, such as `"N/A"`
- `compact:` (Boolean, default `false`) — a small tile with an extra small label and a smaller value, with its change or note beside the value, about 58px tall against a default card's 134px. Placed in `ui_grid(cols: { default: 1, sm: 2 }, gap: :sm)` inside a panel, compact cards sit two across and stack one across on a phone
- `label_caps:` (Boolean, default `false`) — draws the label in small capitals

When `definition:` or `calculation:` is given, an info button appears. Hovering or focusing it shows the details in a panel floating below the card, and tapping it toggles the panel on touch screens. The card never changes size.

```erb
<%= ui_stat_card(label: "Revenue", value: "$42,300", variant: :success, suffix: "/mo") %>
<%= ui_stat_card(label: "Merged", value: 12, href: "/pull_requests?state=merged", definition: "Pull requests merged in the range.") %>

<%= ui_grid(cols: { default: 1, sm: 2 }, gap: :sm) do %>
  <%= ui_stat_card(label: "Flipped to pass", value: 14, variant: :success, compact: true) %>
  <%= ui_stat_card(label: "Avg tokens out", value: 302, change: -4.0, compact: true) %>
<% end %>
```

### `ui_calculation`

Shows the working behind a figure, closed by default under a quiet "How this is worked out" row, so a reader can check how a number was reached without it taking over the page. Put it under the figure it explains, such as a `ui_stat_card`.

**Required props**

- `groups:` (Array of Hashes) — each with `lines:` and an optional `title:`. Each line is a Hash with `label:`, `working:` and `result:`.

**Optional props**

- `summary:` (String, default `"How this is worked out"`) — the text on the row that opens it

Each line is laid out as its label, its working and its result in three columns, in the same quiet text as a form hint.

```erb
<%= ui_stat_card(label: "Perfect value", value: "$107,695.00") %>
<%= ui_calculation(groups: [
  { title: "Store runs", lines: [
    { label: "Money a year", working: "$34.00 × 1,825", result: "$62,050.00" },
    { label: "Time a year", working: "1 hour × 1,825 × $25.00 an hour", result: "$45,625.00" }
  ] },
  { title: "How it adds up", lines: [
    { label: "Perfect value", working: "$107,675.00 in costs + $20.00 missed out", result: "$107,695.00" }
  ] }
]) %>
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

- `tabs:` (Array of Strings) — tab labels, switched in the browser by the `tab-switcher` controller
- `tabs:` (Array of Hashes) — link tabs, each `{ label:, href:, current:, count: }`, where `current: true` marks the chosen tab and `count:` is drawn after the label when it is above zero. A tab given `show_zero: true` also draws a count of zero

**Optional props**

- `align:` (Symbol, default `:center`) — `:start` starts the tab row at the left edge on every width instead of centring it from `sm` up
- `shape:` (Symbol, default `nil`) — `:pills` draws each tab as an outlined pill and `:underline` draws the tabs on a line with the chosen tab underlined, and with no shape the tabs are drawn as before
- `id:` (String, default `nil`) — the `id` of the tab row, so a Turbo Stream can replace the row, with its labels and counts, without redrawing the content under it

```erb
<%= ui_tab_switcher(tabs: ["Overview", "Details", "History"]) do %>
  <!-- tab panel content -->
<% end %>
```

Link tabs name the chosen tab in the page address. Each tab is a link, the chosen one is drawn active with `aria-current="page"`, and following one replaces the current history entry. The host reads the chosen tab from its params and draws only that tab's content in the block.

```erb
<% tab = params[:tab].presence_in(%w[offer value]) || "offer" %>
<%= ui_tab_switcher(tabs: [
  { label: "Offer", href: offer_path(@offer, tab: "offer"), current: tab == "offer" },
  { label: "Value", href: offer_path(@offer, tab: "value"), current: tab == "value" }
]) do %>
  <%= render "offers/#{tab}", offer: @offer %>
<% end %>
```

A link tab's count is drawn in an info badge, as a navigation item draws its count. In a tab row with a `shape:` the count is drawn as plain muted text after the label, and the shape sets the tabs' text size.

```erb
<%= ui_tab_switcher(align: :start, shape: :pills, tabs: [
  { label: "All", href: inbox_path, count: 7, current: filter.nil? },
  { label: "Approvals", href: inbox_path(filter: "approvals"), count: 4, current: filter == "approvals" }
]) do %>
  <%= render "inbox/items", items: @items %>
<% end %>
```

A link tab row given an `id:` is replaced on its own by a fresh render with no block, since a tab switcher with no block, summary or panels draws only its row.

```erb
<%= turbo_stream.replace "offer_tabs" do %>
  <%= ui_tab_switcher(id: "offer_tabs", tabs: [
    { label: "Offer", href: offer_path(@offer, tab: "offer"), current: tab == "offer" },
    { label: "Problems", href: offer_path(@offer, tab: "problems"), count: @offer.problems.count, current: tab == "problems" }
  ]) %>
<% end %>
```

Below `sm` the tab row stays on one line, starts at the left edge and scrolls sideways when its tabs do not fit, and no tab label wraps onto a second line. From `sm` up it wraps and is centred, or starts at the left edge with `align: :start`.

**Slots**

- `panels` — one panel per label tab, in the order of `tabs:`. The first panel shows when the page opens, and choosing a tab shows its panel and hides the others on the same page, so values typed into fields on any panel are kept. The fields of a hidden panel are disabled, so a required field on a hidden tab does not stop the form being sent and is not submitted

```erb
<%= form_with url: sign_up_path do %>
  <%= ui_tab_switcher(tabs: ["Password", "Emailed code"]) do |switcher| %>
    <% switcher.with_panel do %>
      <%= ui_form_field(attribute: :password, type: :password, required: true) %>
    <% end %>
    <% switcher.with_panel do %>
      <%= ui_form_field(attribute: :email, type: :email, required: true) %>
    <% end %>
  <% end %>
<% end %>
```

- `summary` — content that sits with the tabs, such as stat cards. From `sm` up it is drawn above the tab row. Below `sm` it is drawn between the tab row and the panel, so a phone reaches the tabs first. The summary is drawn once, and the host writes no width-specific classes.

```erb
<%= ui_tab_switcher(tabs: tabs) do |switcher| %>
  <% switcher.with_summary do %>
    <%= render "offers/stats", offer: @offer %>
  <% end %>
  <%= render "offers/#{tab}", offer: @offer %>
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
- `height:` (`:screen | :content`, default `:screen`) — `:screen` keeps the hero at least the full screen height, and `:content` draws it only as tall as its content and its padding
- `title_size:` (`:lg | :sm`, default `:lg`) — `:sm` draws the title smaller, as on a quiz's intro page

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

Renders an HSV color picker with swatch preview and a text field holding its value. Uses Stimulus `color-picker` controller.

A colour typed in the text field as hex, `rgb()`, `hsl()` or `oklch()` is drawn in the swatch and submitted exactly as typed. A typed value the browser cannot read as a colour is not drawn or submitted. A colour chosen in the hue panel is submitted as six-digit hex.

**Required props**

- `name:` (String) — form input name

**Optional props**

- `value:` (String, default `"#000000"`) — initial colour, as hex, `rgb()`, `hsl()` or `oklch()`
- `label:` (String)

```erb
<%= ui_color_picker(name: "accent_color", value: "#3b82f6", label: "Accent") %>
```

### `ui_navbar`

Renders the top-level navigation bar with slots for desktop and mobile sections. Sticky by default.

**Optional props**

- `sticky:` (Boolean, default `true`)
- `hide_logo_on_mobile:` (Boolean, default `false`). Hides the `logo` slot below `lg` and keeps it from `lg` up, for a page that shows its own title in the phone header.

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

### `ui_navigation`

Draws the app's declared tabs as a top bar on `lg` screens and wider, or as a sidebar when the person's saved placement is left or right as described below, then the page content the layout passes as a block. Each declared group is a menu in the top bar holding its tabs, and each tab declared outside any group is a plain link, in declared order unless the person saved an order as described below. A tab whose permission check fails for the view is left out, and so is a group whose tabs are all left out. Below `lg` it draws only the page content, so the phone's bottom tab bar and mobile header stay as they are. With no tabs declared, or none the person may see, it draws only the page content, unless the layout hands it a logo or menus as shown below. Whenever it draws a top bar or a sidebar, it hands the layout one element holding both the navigation and the page content, so a layout that arranges the body's children, such as a grid of header, stretching row and footer, sees the same single element in every placement.

```erb
<%= ui_navigation do %>
  <%= yield %>
<% end %>
```

To put the app's logo and its menus, such as the account menu and the user menu, in the same top bar, set them inside the block. The logo is drawn at the left end of the bar and the menus at its right end, after the tabs. A layout that sets neither gets a bar holding only the tabs. When the person may see no tab, a layout that sets either still gets the bar, holding just the logo and menus.

```erb
<%= ui_navigation do |navigation| %>
  <% navigation.with_logo do %>
    <%= link_to "MyApp", root_path %>
  <% end %>
  <% navigation.with_menus do %>
    <%= ui_nav_dropdown(title: "Account", area: "account") do %>
      <%= link_to "Settings", settings_path %>
    <% end %>
  <% end %>
  <%= yield %>
<% end %>
```

The navigation asks `config.preference_supplier` for the key `:navigation` and reads the placement under `"placement"` in the returned `value`. With `"left"` or `"right"` it draws a sidebar on that side of the page content on `lg` screens and wider, showing each group as its label alone, which opens to list the group's tabs when clicked and closes when clicked again, with the group holding the current page's tab open when the page loads, the logo at the top and the menus at the bottom. An open group's tabs sit inside one element with the class `ks-sidebar-group-tabs`, so a stylesheet can draw a border around them and lines between them, and a tab declared outside any group is never inside one. A menu in the sidebar opens in place: the panel marked `data-dropdown-target="menu"` inside an element with `data-controller="dropdown"` is drawn on its own line below its button, inside the sidebar, instead of as a dropdown laid over it, even when the app's own stylesheet positions that panel absolutely, as long as that stylesheet is in a CSS layer below Tailwind's utilities, such as `components`. A closed menu's panel, marked by the `hidden` class both the gem's dropdown controller and tailwindcss-stimulus-components toggle, stays out of sight, out of the keyboard's tab order and away from screen readers, but still counts toward the sidebar's width, so the sidebar is always as wide as its widest item and opening or closing a menu never changes it. The sidebar scrolls when its content is taller than the screen. Menus in the top bar still open as dropdowns. Below `lg` the sidebar is not drawn and the page content takes the full width. With `"top"`, no supplier, no saved value or any other placement it draws the top bar. A gem that stores preferences, such as keystone_ui-preferences, sets the supplier for the app.

For the `:navigation` key the supplier returns the saved value in this shape:

```ruby
{ value: { "placement" => "left" } }
```

The same value may hold the person's order of groups and tabs under `"order"`, a list with one entry per group. Each entry names a group by its declared label under `"group"`, and may list that group's tab keys as strings under `"tabs"`. Both placements draw the groups, and each group's tabs, in that order. Groups and tabs the order does not name come after the named ones, in declared order. A group label or tab key in the order that is no longer declared is ignored.

```ruby
{ value: { "placement" => "left", "order" => [ { "group" => "Admin" }, { "group" => "Sales", "tabs" => [ "orders", "quotes" ] } ] } }
```

Declare the groups and tabs in the app's Keystone UI initializer. A tab's `href:` is an address or a lambda that receives the view and returns one, and `permitted:` is a lambda that receives the view and returns whether the current person may see the tab.

```ruby
KeystoneUi.configure do |config|
  config.navigation_group "Sales" do |group|
    group.tab :quotes, label: "Quotes", href: ->(view) { view.quotes_path }, permitted: ->(view) { view.policy(Quote).index? }
    group.tab :orders, label: "Orders", href: "/orders", permitted: ->(_view) { true }
  end
end
```

To show a tab on its own, outside any group, declare it with `config.navigation_tab`, which takes the same key, `label:`, `href:` and `permitted:` as a group's tab. The top bar draws it as a plain link among the menus, and the sidebar draws it as a plain tab with no group label, which does not open or close, in the place it was declared among the groups. A saved order names it under `"group"` by its label, the same as a group.

Either kind of tab takes an optional `count:`, a callable given the view that returns a number, such as how many items are waiting on the signed-in person. The top bar and the sidebar show a count above zero in an info badge after the tab's label, and show nothing for zero or `nil`. The callable runs on every page the navigation draws, so keep it to one cheap query.

```ruby
config.navigation_tab :questions, label: "Questions", href: "/questions", permitted: ->(_view) { true },
  count: ->(view) { Question.waiting.where(assignee: view.current_user).count }
```

```ruby
KeystoneUi.configure do |config|
  config.navigation_tab :console, label: "Console", href: "/console", permitted: ->(_view) { true }
  config.navigation_group "Sales" do |group|
    group.tab :quotes, label: "Quotes", href: "/quotes", permitted: ->(_view) { true }
  end
end
```

Boot stops with `KeystoneUi::NavigationCheck::Error` when a declared tab has no label or no `href:`, naming the tab's key, when two declared tabs share a key, naming the key, or when a declared group has no tabs, naming the group, so a mistake shows up the moment the app starts. It does not check that a tab's link leads to a page that exists.

To mark where the person is, set `config.current_tab_supplier` to a lambda that receives the view and returns the key of the declared tab the current page belongs to. The top bar shows that tab and the menu holding it as active, and the sidebar gives that tab and its group's label the `active` class. A tab declared outside any group is marked the same way, with no menu or group label to mark. Returning `nil` or a key no declared tab has marks nothing, and so does setting no supplier. In this example each controller names its tab, and a controller that names none marks nothing:

```ruby
KeystoneUi.configure do |config|
  config.current_tab_supplier = ->(view) { view.controller.try(:navigation_tab) }
end
```

```ruby
class QuotesController < ApplicationController
  def navigation_tab = :quotes
end
```

To hide a whole group from a person, set `config.hidden_group_supplier` to a lambda that receives the view and a group's label and returns true to hide that group. A tab declared outside any group is hidden the same way, by its label. A hidden group is left out of the top bar, the sidebar and every other menu drawn from keystone_ui's list of the person's groups. Setting no supplier hides nothing. In this example a gem hides the groups the account has turned off:

```ruby
KeystoneUi.configure do |config|
  config.hidden_group_supplier = ->(view, label) { view.turned_off_groups.include?(label) }
end
```

### `ui_nav_item`

Renders a single nav link within the navbar.

**Required props**

- `label:` (String)
- `href:` (String)

**Optional props**

- `active:` (Boolean, default `false`)
- `count:` (Integer) — shown in an info badge after the label when above zero

```erb
<%= ui_nav_item(label: "Dashboard", href: "/", active: current_page?(root_path)) %>
```

### `ui_nav_dropdown`

Renders a dropdown menu within the navbar. Uses Stimulus `dropdown` controller. A title too long for the trigger is cut short with an ellipsis, so the phone top bar never makes the page wider than the screen.

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
- `count:` (Integer) — shown in an info badge over the icon when above zero

```erb
<%= ui_bottom_nav_item(label: "Home", href: "/", icon: "<svg>…</svg>", active: true) %>
```

### `ui_mobile_header`

Renders a mobile header with back link, title, and optional subtitle, overline and badge. Hidden on `lg:` screens. With a `nil` `back_url:` it shows no back link and leaves no space for one, so the title starts at the header's left edge, as on a nav tab's own page.

Placed outside a top bar, such as directly in the layout's `<header>`, it draws the back link, title and subtitle in one row with the same side margin as `ui_page`, and text too long for the screen ends in an ellipsis. Inside an element with the `top-nav` class, such as `ui_navbar`, that row gives way, and the back link and title are laid out by the bar: the title and subtitle sit between the back link and the bar's right-side controls and start at the left of that space. In `ui_navbar`'s `mobile_left` slot, controls that leave less than 6rem for the title move to a second row under it. In a hand-written top bar, give the bar the `top-nav` class, make the header a direct child of the bar's flex row, and add `max-lg:has-[.ks-mobile-header-title]:flex-wrap` to the bar if its controls can fill its width.

An overline is a short line of small muted text shown above the title, such as the list the page belongs to. It ends in an ellipsis when too long, as the title does. A badge is drawn with `ui_badge`'s look at the right end of the header, after the title and before a top bar's own right-side controls. It keeps its full width and its own height, so a long title is cut short with an ellipsis and never pushes the badge off the screen.

**Required props**

- `title:` (String)
- `back_url:` (String)

**Optional props**

- `subtitle:` (String) — shown under the title
- `overline:` (String) — shown above the title
- `badge:` (Hash) — `label:` and an optional `variant:` (`:neutral`, `:success`, `:danger`, `:warning` or `:info`), the keywords `ui_badge` takes

```erb
<%= ui_mobile_header(title: "Edit Product", back_url: products_path) %>

<%= ui_mobile_header(title: "Approve variants", back_url: nil, overline: "Inbox · 7 items", badge: { label: "46h left", variant: :warning }) %>
```

### `ui_action_menu`

Renders an ellipsis (⋯) button that opens a dropdown of actions, at every screen size. Uses the Stimulus `action-menu` controller. The menu opens under its button, or above it when there is no room below, and at the top of the screen when it fits neither way. An open menu moves with its button while the page scrolls, and closes when a tap or click is released outside it or the screen resizes. Fill it with `ui_action_menu_item`.

```erb
<%= ui_action_menu do %>
  <%= ui_action_menu_item(label: "Edit", href: edit_product_path(@product)) %>
  <%= ui_action_menu_item(label: "Delete", href: product_path(@product), method: :delete) %>
<% end %>
```

### `ui_action_menu_item`

One entry in an action menu. A link when `method:` is `:get`, and a form button that sends the method otherwise. An item that deletes asks for confirmation first.

| Param | Required | Default |
|-------|----------|---------|
| `label:` | yes | — |
| `href:` | yes | — |
| `method:` | no | `:get` |
| `confirm:` | no | `nil` | a question asked before the item runs. An item with `method: :delete` asks "<label> this? This cannot be undone." when none is given. |

### `ui_mobile_actions`

Renders an ellipsis dropdown for mobile action menus. Hidden on `lg:` screens. Uses the Stimulus `action-menu` controller, so it opens, moves and closes as `ui_action_menu` does.

No props. Pass action links as block content.

```erb
<%= ui_mobile_actions do %>
  <%= link_to "Edit", edit_product_path(@product) %>
  <%= link_to "Delete", product_path(@product), data: { turbo_method: :delete } %>
<% end %>
```

### `ui_mobile_action`

Draws the action a screen gives `ui_page_header` through `action_url:` as a plus icon link in the phone top bar, named with `action_label:`. When the screen also gives `action_method:`, the icon is a button in a form that sends that method to the address with the authenticity token. It draws nothing on a screen with no action. It is hidden from `sm` screens up, where the page header shows the action. A page header given badges or a menu is also shown below `sm` with its action, so on such a page the action shows twice there. It is also hidden when the page is printed and inside a Hotwire Native web view, where the layout writes the `hotwire-native` class on `<html>` and declares that Tailwind variant, so give native users another way to reach the action, such as `ui_mobile_actions`.

No props. Call it from the layout's top bar, which is rendered after the screen.

```erb
<%= ui_navbar do |nav| %>
  <% nav.with_mobile_right do %>
    <%= ui_mobile_action %>
  <% end %>
<% end %>
```

### `ui_bottom_action`

Draws the action a screen gives `ui_page_header` through `action_url:` as a full-width button fixed to the bottom of a phone screen, labelled with `action_label:`. When the screen also gives `action_method:`, the button is a form that sends that method to the address. It draws nothing on a screen with no action. It is hidden from `sm` screens up, inside a Hotwire Native web view and when the page is printed, as `ui_mobile_action` is. On a page that shows the bottom nav it sits directly above the bottom nav. It also draws an invisible, inert copy of itself in the page's flow, plus the bottom nav's height when the page has one, so the page's last content can scroll clear of both.

No props. Call it from the layout after the screen, in place of `ui_mobile_action` when the action should sit at the bottom rather than in the top bar. It needs keystone_ui-styles 0.34.0 or later.

```erb
<%= yield %>
<%= ui_bottom_action %>
```

### `ui_decision_bar`

Draws one form holding a note field, secondary buttons and a primary button, which the page's reader uses to decide on an item, such as approving, rejecting or sending it back. The button pressed is sent with the note, so its `name:` and `value:` tell the controller which decision was made.

From `sm` screens up it is a panel showing the note field with its label, then the secondary buttons, then the primary button, on one line that wraps when it runs out of width, with the hint on its own line under them.

Below `sm` it is a bar fixed to the bottom of the screen, above the bottom nav on a page that has one. The primary button spans the full width and is 48px tall, and the secondary buttons sit in a row under it, each taking an equal share of the width and 44px tall. A label too long for its share wraps inside its button. The note field and hint are not shown there. The bar stays shown inside a Hotwire Native web view, at the bottom of the web view. It draws an invisible, inert copy of itself in the page's flow, plus the bottom nav's height when the page has one, so the page's last content can scroll clear of both.

**Required props**

- `url:` (String) — where the form is sent
- `primary:` (Hash) — `ui_button` keywords for the primary button, usually `label:`, `name:` and `value:`

**Optional props**

- `actions:` (Array of Hashes) — `ui_button` keywords for each secondary button, three at most on a phone so the phone row fits. Below the bar's breakpoint each label is drawn in small text, so a label such as "Send back" stays on one line three across on a 390px-wide screen. One with `href:` is a link, such as a link to the next item. Each also takes:
  - `phone_label:` (String) — a shorter label shown below `sm` in place of `label:`
  - `phone_only:` (Boolean) — shows the action below `sm` only
  - `phone_order:` (1, 2 or 3) — the action's place in the phone row, so the phone row can list the actions in another order than the desktop row. Any other value raises `KeyError`
  - `href:` with `method:` such as `:delete` — the button sends the bar's form to its own `href:` with that method, and the other buttons still send it to `url:` with `method:`. Such an action given its own `name:` or `value:` raises `ArgumentError`, since the button sends its method in their place
- `note:` (Hash) — `name:`, `label:` and `placeholder:` of a text field sent with the form
- `hint:` (String) — a short line under the buttons, such as the keyboard keys the page answers to
- `method:` (Symbol, default `:post`)
- `breakpoint:` (`:sm | :md | :lg`, default `:sm`) — the screen width at which the bar switches from its phone form to its panel, 640px, 768px or 1024px, so it can match a page that changes its own layout at another width

Do not show `ui_bottom_action` on the same screen.

```erb
<%= ui_decision_bar(
  url: approval_decision_path(@approval),
  note: { name: "note", label: "Note", placeholder: "Optional. Saved as a label on this execution." },
  actions: [
    { label: "Reject", name: "decision", value: "reject", phone_order: 2 },
    { label: "Send back with findings", phone_label: "Send back", name: "decision", value: "send_back", phone_order: 1 },
    { label: "Next ›", href: next_approval_path(@approval), phone_only: true, phone_order: 3 }
  ],
  primary: { label: "Approve all 3", name: "decision", value: "approve" },
  hint: "Keyboard: J/K next/prev · A approve · R reject"
) %>
```

### `ui_form_page`

Wraps a form page with title and back navigation. Sets `content_for` signals so the navbar can render mobile header context. On `lg` screens and wider, where the mobile header is hidden, it shows a link back to `back_url` at the top of the page's `ui_page`, so call `ui_page` on the same page.

**Required props**

- `title:` (String)

**Optional props**

- `back_url:` (String) — defaults to the last link of the trail; with no `back_url:` and no trail, rendering raises `KeystoneUi::MissingBackLink` naming the page, while an empty trail needs no `back_url:`
- `subtitle:` (String)
- `trail:` (Array of `[label, href]` pairs) — the pages above this one; on `lg` screens and wider, the back link sits above breadcrumbs ending with `title`. An empty trail marks a nav tab's own page, which shows no back link and no breadcrumbs. When the page passes none, it uses the trail the app supplies through `config.trail_supplier`

```erb
<%= ui_form_page(title: "New Product", back_url: products_path) %>
<%= ui_form_page(title: "New Product", back_url: products_path, trail: [["Catalog", catalog_path], ["Products", products_path]]) %>
```

### `ui_show_page`

Wraps a show/detail page with title and back navigation. Sets `content_for` signals so the navbar can render mobile header context. On `lg` screens and wider, where the mobile header is hidden, it shows a link back to `back_url` at the top of the page's `ui_page`, so call `ui_page` on the same page.

**Required props**

- `title:` (String)

**Optional props**

- `back_url:` (String) — defaults to the last link of the trail; with no `back_url:` and no trail, rendering raises `KeystoneUi::MissingBackLink` naming the page, while an empty trail needs no `back_url:`
- `subtitle:` (String)
- `trail:` (Array of `[label, href]` pairs) — the pages above this one; on `lg` screens and wider, the back link sits above breadcrumbs ending with `title`. An empty trail marks a nav tab's own page, which shows no back link and no breadcrumbs. When the page passes none, it uses the trail the app supplies through `config.trail_supplier`

```erb
<%= ui_show_page(title: @product.name, back_url: products_path, subtitle: "Details") %>
<%= ui_show_page(title: @product.name, back_url: products_path, trail: [["Catalog", catalog_path], ["Products", products_path]]) %>
```

#### Supplying every page's trail from the app

Set `config.trail_supplier` to a lambda that receives the view and returns that page's trail. `ui_form_page` and `ui_show_page` call it when the page passes no `trail:`, and a page that passes no `back_url:` goes back to the trail's last link. Returning `nil` leaves the page with its own `back_url` and no breadcrumbs. Returning `[]` marks the page as a nav tab's own page, which shows no back link and no breadcrumbs.

```ruby
KeystoneUi.configure do |config|
  config.trail_supplier = ->(view) { Breadcrumbs.trail_for(view) }
end
```

### `ui_breadcrumbs`

Shows the pages above the current one as links separated by `›`, ending with the current page, which is not linked. Shown on `lg` screens and wider only, where the mobile header is hidden. Use it on a page that uses neither `ui_form_page` nor `ui_show_page`; those two take the same trail through `trail:`.

**Required props**

- `trail:` (Array of `[label, href]` pairs)

**Optional props**

- `current:` (String) — the current page, shown last

```erb
<%= ui_breadcrumbs(trail: [["Catalog", catalog_path]], current: "Products") %>
```

### `ui_settings_link`

Renders a settings row link with label and chevron icon.

**Required props**

- `label:` (String)
- `href:` (String)

```erb
<%= ui_settings_link(label: "Account", href: account_settings_path) %>
```

## Releasing

Cutting a new version to RubyGems.org is documented in [RELEASING.md](RELEASING.md).
