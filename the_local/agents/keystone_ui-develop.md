---
name: keystone_ui-develop
description: Use PROACTIVELY for building or editing screens in a Rails app that has Keystone UI — pages, forms, tables, navigation, dashboards, charts, marketing sections — MUST BE USED instead of hand-writing ERB and Tailwind for UI.
tools: Read, Write, Edit, Grep
scope: UI — pages, forms, tables, navigation, dashboards
---

This local builds screens by composing Keystone UI's `ui_*` view helpers in ERB.
It always works the same way: pick the page shell, fill it with the helpers that
match the content, and write no Tailwind classes of its own.

## What Keystone UI is

Keystone UI is a Rails engine that supplies an app's visual layer as a library of
view helpers. Each helper renders one named piece — a page shell, a section, a
form field, a data table, a navigation bar, a stat card, a chart — with all
styling and dark-mode treatment owned inside the gem. Two screens built from the
same helpers cannot drift apart, and a change to a piece updates every screen at
once. It is mobile-first: several helpers ship distinct mobile and desktop
treatments, which matters because these apps are often viewed in a native
webview.

Fire on any request to build or change a screen, view, form, table, navigation,
or dashboard in an app that has Keystone UI installed. If the `ui_*` helpers are
not available in the app yet, that is the `keystone_ui-install` local's job, not
this one's.

## Interface

Every entry point is a view helper called from ERB. Keywords with defaults are
optional; the rest are required. Symbol options are validated — an unrecognized
one raises at render time. Two exceptions: `ui_page`'s `padding:` treats any
value other than `:none` as `:standard`, and `ui_pipeline`'s box `accent:` falls
back to `:muted`.

Six helpers — `ui_page`, `ui_section`, `ui_page_header`, `ui_card`, `ui_alert`,
`ui_badge` — also accept `class:`, a string of classes appended to the helper's
outer element. See Conventions before using it.

### Page shells and layout

- `ui_page(max_width: :full, padding: :standard, top_offset: nil, class: nil)` —
  takes a block. The outer wrapper for a screen. `max_width:` `:sm` `:md` `:lg`
  `:xl` `:full`; `padding:` `:standard` or `:none`; `top_offset:` `:sm` `:md`
  `:lg` `:xl` to clear a fixed navbar.
- `ui_section(title: nil, subtitle: nil, action: nil, spacing: :md, class: nil)`
  — takes a block. A titled block of content with an optional right-aligned
  link. `action:` is `{ label:, href: }`; `spacing:` `:sm` `:md` `:lg`.
- `ui_panel(padding: :md, radius: :lg, shadow: true)` — takes a block. A bordered
  card surface. `padding:` `:sm` `:md` `:lg`; `radius:` `:md` `:lg` `:xl`.
- `ui_grid(cols: { default: 1 }, gap: :md, gap_x: nil, gap_y: nil)` — takes a
  block. A responsive grid. `cols:` maps breakpoints `:default` `:sm` `:md` `:lg`
  to a column count 1–12, e.g. `{ default: 1, md: 3 }`. `gap:` `:sm` `:md` `:lg`
  `:xl`; passing `gap_x:`/`gap_y:` replaces `gap:` entirely.
- `ui_card_link(href:, padding: :md, shadow: true)` — takes a block. A whole
  panel that is one link. `padding:` `:sm` `:md` `:lg`.
- `ui_card(title:, summary:, link:, cta: "Read more", edge_to_edge: false, class: nil)`
  — a fixed title/summary/CTA card. `edge_to_edge: true` drops the side border and
  corner rounding below `sm:` so it spans the full width on mobile.
- `ui_page_header(title:, subtitle: nil, action_url: nil, action_label: "Add new", class: nil)`
  — takes a block yielding the header. Desktop-only page title (hidden below
  `sm:`). Call `header.action { ... }` in the block to place a custom control on
  the right; only what `action` receives is rendered. Passing `action_url:`
  publishes that URL and label for a mobile navbar to pick up.
- `ui_form_page(title:, back_url:, subtitle: nil)` — the shell marker for a form
  screen. Renders the desktop title block and publishes the title and back URL so
  the navbar can render mobile header context.
- `ui_show_page(title:, back_url:, subtitle: nil)` — the shell marker for a
  detail screen. Renders nothing itself; only publishes the title, subtitle, and
  back URL for the navbar.

### Navigation

- `ui_navbar(sticky: true)` — takes a block yielding the navbar. Fill named slots
  on it: `logo`, `desktop_links`, `desktop_right`, `mobile_left`,
  `mobile_center`, `mobile_right`. Desktop slots are hidden below `lg:` and the
  mobile slots above it. `desktop_right` renders only when `desktop_links` is
  also filled.
- `ui_nav_item(label:, href:, active: false)` — one desktop navigation link.
- `ui_nav_dropdown(title:, area:, active: false)` — takes a block. A navbar
  dropdown; the block holds the menu links.
- `ui_bottom_nav` — no keywords, takes a block. The mobile bottom tab bar; hidden
  above `lg:` and inside a Hotwire Native webview.
- `ui_bottom_nav_item(label:, href:, icon:, active: false)` — one bottom tab.
  `icon:` is a raw SVG string.
- `ui_mobile_header(title:, back_url:, subtitle: nil)` — a back chevron plus
  centered title for mobile; hidden above `lg:`. Place it in the navbar's
  `mobile_left` slot.
- `ui_mobile_actions` — no keywords, takes a block. An ellipsis dropdown for
  mobile actions; the block holds the menu items. Hidden above `lg:`.
- `ui_settings_link(label:, href:)` — a full-width settings row with a chevron.

### Forms

- `ui_form(action:, method: :post, multipart: false, data: nil)` — takes a block.
  The `<form>` wrapper. `method:` may be `:patch`/`:put`/`:delete` and is
  translated for Rails. Set `multipart: true` when the form contains a file
  upload.
- `ui_form_field(attribute:, label: nil, type: :text, required: false, hint: nil, placeholder: nil, min: nil, max: nil, step: nil, value: nil, options: [], errors: [])`
  — a labeled field with hint and error text. This is the default way to render
  an input. `type:` `:text` `:number` `:email` `:password` `:date` `:textarea`
  `:checkbox` `:select`. `attribute:` is used verbatim as the input's `name`, so
  pass the full param name the controller expects, e.g. `"quote[title]"`, and
  pass `label:` whenever the attribute is a nested name. `label:` defaults to the
  attribute with underscores turned to spaces and the first letter capitalized.
  `options:` is for `:select` and takes `[[label, value], ...]`; `value:` picks
  the selected option, and a non-required select gets a leading blank option. A
  `:checkbox` renders its label beside the box, submits `"0"` when unchecked and
  `"1"` when checked, and pre-checks when `value:` is `"1"`. `errors:` is an
  array of message strings.
- `ui_input(name:, type: :text, value: nil, placeholder: nil, disabled: false, min: nil, max: nil, step: nil)`
  — a bare styled input with no label. `type:` `:text` `:number` `:email`
  `:password` `:date`.
- `ui_textarea(name:, value: nil, rows: 3, placeholder: nil, disabled: false)` —
  a bare styled textarea.
- `ui_select(name:, options: [], selected: nil, include_blank: nil, disabled: false)`
  — a bare styled select. `options:` is `[[label, value], ...]`;
  `include_blank:` is the text of a leading empty option.
- `ui_multi_select(name:, label:, options:, selected: [])` — a dropdown of
  checkboxes all posting under `name`, used verbatim; pass an array name such as
  `"status[]"` so every checked value arrives. `options:` is
  `[[label, value], ...]`; `selected:` is the values to pre-check. The trigger
  reads "All <label>" when nothing is checked and "N selected" otherwise.
- `ui_file_upload(name:, label: nil, accept: nil, multiple: false, hint: nil)` —
  a drop zone with drag-and-drop and selected-file feedback. Requires the
  enclosing form to be multipart.
- `ui_color_picker(name:, value: "#000000", label: nil)` — a swatch that opens a
  hue/saturation panel and writes the hex into a hidden input named `name`.
- `ui_radio_card(name:, value:, label:, hint: nil, checked: false)` — a
  selectable card backed by a real radio input; selection styling is pure CSS.
- `ui_checkbox_row(name:, value:, label:, hint: nil, checked: false)` — a real
  checkbox with its label and optional hint inside one `<label>`, so a tap
  anywhere on the row toggles the box. A checked row submits `value` under
  `name`; give several rows the same array name, e.g. `"shown[]"`, to submit the
  checked values as a list. An unchecked row submits nothing. No JavaScript.
- `ui_option_card(name:, value:, selected: false, input_data: {}, label_data: {})`
  — takes a block. A radio whose visible body is whatever the block renders.
  `input_data:`/`label_data:` become `data-*` attributes on the input and label.

### Tables

- `ui_data_table(items:, columns:, empty_message: nil, sort: nil, sort_direction: nil, sort_url: nil, hidden_columns: [])`
  — takes a block yielding the table. `items:` are records or hashes; each cell
  value is read by calling the column key on the item, falling back to `item[key]`.
  `columns:` accepts plain `{ key: "Label" }` hashes or `Keystone::Ui::Column`
  objects. In the block, `table.link(:column_key) { |item| url }` turns that
  column's cells into links and `table.actions { |item| ... }` appends a
  right-aligned actions column. Sorting requires all three of `sort:` (the
  current column key), `sort_direction:` (`:asc`/`:desc`), and `sort_url:` (a
  lambda taking `(column_key, direction)` and returning a URL); headers then
  render as links that flip direction. `hidden_columns:` drops columns
  server-side and only affects columns declared `hideable: true`.
- `Keystone::Ui::Column.new(key, header_text, mobile_hidden: false, sortable: false, hideable: false)`
  — a column with per-column options, for when a `{ key: "Label" }` hash is not
  enough. `mobile_hidden:` hides the column below `sm:`; `sortable:` opts it into
  sort headers; `hideable:` lets the column picker hide it.
- `ui_column_picker(columns:, hidden_columns: [], save_url: nil)` — a "Columns"
  dropdown of checkboxes for every `hideable` column. Pass it the same columns
  and hidden keys as the table. On toggle it sends `PATCH save_url` with JSON
  `{ "hidden_columns": ["key", ...] }` and a `X-CSRF-Token` header, then reloads
  the page. The app must provide that endpoint and persist the list.

### Content and status

- `ui_button(label:, href: nil, variant: :primary, size: :md, type: :submit, data: nil)`
  — renders an `<a>` when `href:` is given and a `<button>` otherwise. `variant:`
  `:primary` `:secondary` `:danger`; `size:` `:sm` `:md` `:lg`; `type:` applies
  only to the button form.
- `ui_badge(label:, variant: :neutral, class: nil)` — a pill. `variant:`
  `:neutral` `:success` `:danger` `:warning` `:info`.
- `ui_alert(message:, type: :info, title: nil, dismissible: false, class: nil)` —
  a banner.
  `type:` `:info` `:success` `:warning` `:error`. `dismissible: true` adds a
  close control.
- `ui_progress(value:, max:, label: nil)` — a labeled progress bar. The percent
  is `value / max`, rounded and clamped at 100.
- `ui_stat_card(label:, value:, variant: :neutral, suffix: nil, definition: nil, calculation: nil, change: nil, href: nil)`
  — a single metric tile. `variant:` `:neutral` `:success` `:danger` `:warning`
  `:info` colors the value. `change:` is a signed number rendered as `▲ 4.2%` in
  green when positive, `▼` in red when negative, plain when zero. `href:` makes
  the value a link to its drill-down screen; only the value is linked, never the
  whole card. Passing `definition:` and/or `calculation:` adds an info button
  whose details show in a panel floating below the card while the button is
  hovered or focused, and tapping the button toggles it.
- `ui_copy_button(text:, label: "Copy", success_message: "Copied!", error_message: "Failed!")`
  — copies `text:` to the clipboard.
- `ui_code(language: nil, caption: nil)` — takes a block holding the code. The
  caption is a header strip above the block; `language:` sets the `language-*`
  class for a highlighter.
- `ui_disclosure(open: false)` — takes a block yielding the component. Fill its
  `summary` slot with the clickable header; the rest of the block is the body.
  Native `<details>` — no JavaScript.
- `ui_accordion(items: [])` — a stack of independently expandable rows. `items:`
  is `[{ question:, answer: }, ...]`.
- `ui_tab_switcher(tabs:)` — takes a block. `tabs:` is an array of label strings;
  the first is active on load. The block renders below the tab bar. Selecting a
  tab dispatches a `tab-switcher:change` event carrying the clicked index —
  showing and hiding the matching panels is the app's job.
- `ui_modal(title:, size: :md)` — takes a block holding the body. `size:` `:sm`
  `:md` `:lg` `:xl`. Renders hidden, and closes on its own close button and on a
  backdrop click. Nothing in the gem opens it: the modal's outermost element
  carries the `hidden` class, and the app's own code must remove that class to
  show it. A `data-action="modal#open"` placed outside the modal does nothing.
- `ui_swipe_deck(items:, empty_title: "All done!", empty_subtitle: nil)` — takes
  a block yielding the deck. Call `deck.item { |item| ... }` in the block to
  render one card's face. Accepting a card (button or swipe right) dispatches a
  bubbling `swipe-deck:complete` event and rejecting (button or swipe left)
  dispatches `swipe-deck:skip`. Both carry `detail.itemId` — the item's `id`, or
  its position in `items:` when it has none — and `detail.card`; `complete` also
  carries `detail.value`, read from an input inside the card's face marked
  `data-swipe-deck-value`, or `null`. The app must listen and persist the
  outcome.

### Charts and analytics

- `ui_chart_card(title:, height: :md)` — takes a block holding a chart. `height:`
  `:sm` `:md` `:lg`.
- `ui_line_chart(series:, labels:, height: :md)` — a line chart. `labels:` is the
  x-axis labels; `series:` is `[{ name:, data:, color:, dashed: }, ...]` where
  `color:` (a CSS color string for the line) and `dashed: true` are optional.
  `height:` `:sm` `:md` `:lg`.
- `ui_funnel(steps:)` — a conversion funnel. `steps:` is
  `[{ label:, value:, color: }, ...]` in order, with `color:` optional. Bar
  widths are relative to the first step; the caption between two layers is the
  step-to-step conversion. Each bar takes the next colour in the order
  `:accent` `:sky` `:violet` `:amber` `:rose`, starting again after `:rose`; a
  step passing one of those symbols as `color:` uses it instead, and any other
  symbol raises. Divide-by-zero safe, no JavaScript.
- `ui_bucket(goal:, actual:, label: nil, over: :success)` — an upright container
  for one target, filled from the bottom toward `goal:`. It shows the optional
  `label` on top, then `goal`, the container, `actual`, and the percent reached.
  `goal` and `actual` are printed exactly as given, so pass numbers already
  formatted as needed. The percent is `actual / goal * 100` rounded and **not**
  clamped (so 150% shows as 150%), and it is 0 when `goal` is zero. The fill
  stops at the top once the goal is reached. Within the goal the fill uses the
  accent colour; over it the fill turns green with `over: :success` or amber with
  `over: :warning`, and any other symbol raises. No JavaScript.
- `ui_bucket_series(buckets:)` — a row of buckets that wraps onto more rows on
  narrow screens. `buckets:` is an array of hashes, each taking the same keywords
  as `ui_bucket`, e.g. `[{ goal: 10, actual: 7, label: "Mon" }, ...]`.
- `ui_pipeline(title:, boxes:, links:, subtitle: nil)` — a staged flow diagram
  for event flows, approval chains, or state machines. `boxes:` is
  `[{ label:, count:, accent:, action: }, ...]` where `count:` and `accent:`
  (`:amber` `:emerald` `:danger` `:muted`) are optional, and `action:` is
  `{ url:, label:, params:, variant: }` rendering a button that POSTs `params`
  to `url`. `links:` has exactly one fewer entry than `boxes:`, each
  `{ url:, params:, broken: }`, rendering a ✓/✗ toggle between two boxes that
  POSTs to flip its state. The app owns every endpoint these post to.

### Marketing sections

- `ui_hero(title:, subtitle: nil, badge: nil, layout: :split)` — takes a block
  holding the call-to-action buttons, and yields the component so its `aside`
  slot can hold an image or panel. `layout:` `:split` (content beside the aside)
  or `:centered`.
- `ui_cta_banner(title:, subtitle: nil)` — takes a block holding the
  call-to-action buttons.
- `ui_feature_grid(title:, features:, subtitle: nil)` — a responsive grid of
  feature cards. `features:` is `[{ icon:, title:, description: }, ...]` where
  `icon:` is a raw SVG or HTML string.

## How to use it

1. Confirm the helpers are available in the app. If they are not, stop and hand
   off to `keystone_ui-install` — do not hand-roll the markup in the meantime.

2. Find the closest existing screen in `app/views/` and read it. Match its
   composition before inventing one; that screen is the house style.

3. Pick the page shell for what you are building:
   - a form screen → `ui_form_page`
   - a detail screen → `ui_show_page`
   - anything else → `ui_page`, with `ui_page_header` for the desktop title.

   `ui_form_page` and `ui_show_page` publish their title and back URL for the
   navbar to render as a mobile header. Check the app's layout: if it does not
   already render `ui_mobile_header` from that published context, ask the
   developer whether to wire it before adding more screens that depend on it.

4. Lay out the body with `ui_section` for each titled group, `ui_grid` for
   multi-column arrangements, and `ui_panel` or `ui_card_link` for card
   surfaces. Nest them; each takes a block.

5. Fill the body with the leaf helpers from the Interface above. Reach for the
   most specific one that fits — `ui_form_field` over `ui_input`,
   `ui_data_table` over a hand-built `<table>`, `ui_stat_card` over a panel with
   text in it. To make a stat card clickable, pass `href:` — never wrap it in
   `ui_card_link`, because a tap on the info button would then follow the link.

6. For a table, decide how columns are declared. Use `{ key: "Label" }` hashes
   when every column is plain. Switch the whole set to `Keystone::Ui::Column`
   objects as soon as one column needs `mobile_hidden:`, `sortable:`, or
   `hideable:`.

7. Wire up anything that posts back. Several helpers render controls whose
   endpoints the app must own — the column picker's save URL, the pipeline's box
   and link URLs, the swipe deck's outcome events, the modal's open trigger, the
   tab switcher's panel visibility. Each is named in the Interface. These are
   real decisions about the app's domain: where a preference is persisted, what
   a stage's action does, what happens when a card is accepted. Do not invent
   routes or a persistence strategy — put the choice to the developer, then
   implement what they pick.

8. Read back what you wrote and delete every Tailwind class and inline `style`
   you added. If the result still needs one, that is a signal the wrong helper
   was chosen — go back to step 5. Bring it to the developer only if no helper
   fits.

## Conventions

- **Helpers only.** Call `ui_*` helpers from ERB. Never name a component class
  directly in an app. `Keystone::Ui::Column` is the one exception — it is a value
  object passed as an argument, not a thing that renders.
- **Never hand-write Tailwind for something a helper covers.** Utility classes
  layered onto a helper's output fight the component and drift the moment the gem
  updates. The gem owns spacing, color, borders, radius, shadow, and dark mode.
- **Never restyle a helper from the outside** — no wrapper div that overrides its
  padding or width, no CSS targeting its markup. Choose a different option
  symbol instead, or say the helper does not fit.
- **`class:` needs the developer's approval.** The six helpers that accept it
  append whatever it holds to their outer element, so it can override anything
  the gem sets. Before passing it, name the class and the reason to the
  developer and wait for a yes; if the same class keeps being needed, it is a
  missing option in the gem.
- **Semantic color only.** Themed color is `accent-*` (the brand hue) and
  `surface-*` (the neutral family). Never write a literal color into a view;
  changing the palette is install-local territory.
- **Options are per-helper.** `variant:`, `size:`, `padding:`, and `spacing:` do
  not share one vocabulary — a button's `variant:` and a badge's `variant:`
  accept different symbols. Use the values listed above; a wrong symbol raises at
  render time rather than degrading quietly.
- **Containers take blocks, leaves take keywords.** Helpers that wrap content
  yield; helpers that render one thing are configured entirely by keywords.
  Composite helpers (the navbar, the hero, the disclosure) yield the component so
  named slots can be filled. Helpers that yield a receiver for registration —
  the data table, page header, and swipe deck — only render what was registered
  through it, so anything else emitted inside their block is discarded.
- **Mobile is not an afterthought.** Several helpers render only on one side of
  the `lg:` (or `sm:`) breakpoint — page headers, mobile headers, mobile actions,
  bottom navigation. A screen needs both treatments; check the small viewport
  before calling it done.
- Out of scope for this local: installing or upgrading the gem, changing the
  palette or theme defaults, and editing the components themselves. Building a
  new UI primitive belongs in the gem, not in a host app's views — raise it with
  the developer rather than approximating it locally.
