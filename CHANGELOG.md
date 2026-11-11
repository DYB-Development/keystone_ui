# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- `ui_tab_switcher` takes a `summary` slot, set with `switcher.with_summary`, for content such as stat cards. From `sm` up it is drawn above the tab row, and below `sm` it is drawn between the tab row and the panel, from the same HTML. A tab switcher given no summary draws no wrapper around its tabs and panel.

### Changed
- Below `sm`, a `ui_tab_switcher` tab row stays on one line, starts at the left edge and scrolls sideways when its tabs do not fit, and no tab label wraps onto a second line. From `sm` up it wraps and is centred as before.

## [0.72.0] - 2026-11-10

### Added
- `ui_data_table` takes `header: false`, which draws no heading row, so a list of labels and their values shows no heading such as "Detail" above it. With `phone_list: true` its cells, subtotals and totals then carry no column heading label below `sm` either, so each row shows only its label and its value.

### Changed
- `ui_section` draws its `action:` link and its `menu:` side by side in one row at the right edge of its heading row, at every width, so a section with both no longer shows the link in the middle of the row. A section with neither draws no empty row there.
- The secondary button that `ui_button(variant: :secondary)` and `ui_empty_state` draw is outlined on the surface colour instead of filled grey, since keystone_ui now requires keystone_ui-styles 0.32.0, where that look comes from.
- A `ui_data_table` whose `actions` block renders nothing for every row draws no "Actions" column, and lays out its last column as it does with no `actions` block.
- Below `sm`, every body, subtotal and total cell of a `ui_data_table` given `phone_list: true` starts at the same left edge, so a row's first field is no longer indented further than the fields under it, and a list of labels and values starts each label and value at the same edge. From `sm` up the table looks as it did.
- keystone_ui requires keystone_ui-styles 0.32.0 or later, which styles the `ks-table-phone-list-cell` class those cells carry and the outlined secondary button.
- `ui_page_header` lays out its action buttons side by side in one row at every width, so from `sm` up two buttons no longer stack on top of each other when the header has no menu.
- Below `sm`, a page header given badges or a menu puts its actions and menu on their own full-width row under the title and badges, instead of beside the badges.
- A page header's actions row is never wider than the header, and buttons that do not fit wrap onto another line, so the header never makes the page wider than the screen.
- `ui_mobile_header` draws its back link, title and subtitle in one row with `ks-page`'s side margin, so placed directly in a layout's `<header>` it lines up with the page and a long title ends in an ellipsis instead of making the page wider than the screen. Inside a `.top-nav` element, such as `ui_navbar`, that row is `display: contents` and the bar lays the back link and title out as before, so a hand-written top bar needs the `top-nav` class.
- Below `sm`, a `ui_link_list` row with a badge shows the badge above its label, so the label spans the width of the row beside the chevron instead of sharing it with the badge. From `sm` up the badge sits beside the label as before.

## [0.71.0] - 2026-11-08

### Added
- `ui_data_table` takes `phone_list: true`, and below `sm` it shows the table as a list with one item per row and each cell on its own line under its column's heading, while from `sm` up it looks as it did. A row's links, badges, detail button and action menu stay in its list item, and group subtotals and totals after the first carry their column's heading. A table that does not pass `phone_list:` renders as before at every width.

## [0.70.0] - 2026-11-08

### Added
- `ui_page_header` takes `badges:`, a list of `{ label:, variant: }` hashes, and draws each as a `ui_badge` beside the title, coloured by its variant.
- `ui_page_header` takes `menu:`, a list of hashes of `ui_action_menu_item`'s keywords, and draws them in a `ui_action_menu` beside its actions.

### Changed
- A page header given badges or a menu is now shown below `sm` with its badges, actions and menu, where before every page header was hidden there. A page header with only an action stays hidden below `sm`.
- A page header shown below `sm` hides its title there when the page holds `ui_mobile_header`'s title, so the title is not shown twice.
- A page header given an action along with badges or a menu shows that action below `sm`, so a page that also draws `ui_mobile_action` shows the action twice there.

## [0.69.0] - 2026-11-07

### Added
- `ui_page_header` takes an optional `action_method:`, such as `:post`, and its action button then sends that method to `action_url:` from a form. It passes the method to the layout as `content_for(:mobile_action_method)`, and sets nothing when no method is given.
- `ui_mobile_action` draws its plus icon as a button in a form that sends the published `:mobile_action_method` to the action address with the authenticity token, with the same classes and label as the link. With no published method it is the link it was before.

## [0.68.0] - 2026-11-07

### Added
- `ui_data_table` takes `table.row_detail { |item| ... }` in its block, and what the block returns for an item is drawn in a hidden row under that item's row, in one cell across every column. Clicking the row, or pressing Enter or Space on the caret button at the start of its first cell, opens and closes it, and links, buttons and the action menu in the row work without opening it. An open row stays open when a Turbo refresh morphs the page, through the new `row-detail` Stimulus controller. A row whose block returns `nil`, and a table with no `row_detail`, render as before.

## [0.67.0] - 2026-11-07

### Added
- `ui_tab_switcher` takes tabs as hashes of `label:`, `href:` and an optional `current: true`, drawn as links to each address. The current tab is drawn active with `aria-current="page"`, and following a tab replaces the history entry, so the host draws only the chosen tab's content. Tabs given as plain labels still switch in the browser as before.

## [0.66.0] - 2026-11-06

### Added
- `ui_page_header` passes its `title:` to the layout as `content_for(:mobile_page_title)`, as it does its add action with `:mobile_action_url` and `:mobile_action_label`, and sets nothing when there is no title.

## [0.65.0] - 2026-11-06

### Added
- `ui_form_page` passes its `subtitle:` to the layout as `content_for(:form_page_subtitle)`, as `ui_show_page` does with `:show_page_subtitle`, and sets nothing when there is no subtitle.

## [0.64.0] - 2026-11-06

### Added
- `ui_bottom_nav_item` takes an optional `count:`, shown in an info badge over the tab's icon when it is above zero.

## [0.63.0] - 2026-11-05

### Added
- A navigation tab, declared with `group.tab` or `config.navigation_tab`, takes an optional `count:` callable given the view, such as the number of questions waiting on the signed-in person. The top bar and the sidebar show a count above zero in an info badge after the tab's label, and show nothing for zero or `nil`.
- `ui_nav_item` takes an optional `count:`, shown in an info badge after its label when it is above zero.

## [0.62.0] - 2026-11-05

### Added
- `ui_link_list(rows:)` draws a list of links, one row per `{ label:, href: }` hash, each ending in a chevron. A row may also carry a `subtitle:` shown as a note under its label, a `badge:` of `{ label:, variant: }` and a `value:` shown after the label. It uses the value list row, paragraph and settings link classes keystone_ui-styles already has, so rows are separated by a border and have no hover colour.
- `ui_empty_state(title:, message: nil, action: nil)` shows what a list or section holds when it has nothing in it: a heading, an optional muted message under it, and an optional `{ label:, href: }` action drawn as a secondary button. Its spacing comes from keystone_ui-styles' `ks-empty-state` class, so keystone_ui now requires keystone_ui-styles 0.29.0 or later.
- `ui_data_table` takes `table.row_colour { |item| ... }` in its block. A row whose item the block names `:danger`, `:warning`, `:success` or `:info` has every cell tinted in that colour, using keystone_ui-styles' coloured row classes, and `nil` leaves the row plain.

## [0.61.0] - 2026-11-05

### Added
- `Keystone::Ui::Column` takes `wrap:`. `wrap: true` lets long text in that column's body cells wrap onto more lines inside the cell, so it no longer widens the table. The default, `false`, keeps every cell on one line as before, and headings are unchanged.

## [0.60.0] - 2026-11-04

### Added
- `ui_sortable_list(name:, label:, rows:)` draws a list whose rows can be dragged into a new order with a mouse or a finger, using a handle on each row, so the rest of the row still scrolls the page on a phone. `rows:` is an array of `{ id:, label: }` hashes, and each row holds a hidden field named by `name:` with its id, so the form the list sits in submits the ids in the order shown. Dragging makes no request of its own. Each row also has Move up and Move down buttons named for screen readers, and a change is announced in a status region. Without JavaScript the rows show with no controls and the form submits the starting order. Several lists on one page work independently. This release has not been tested in iPhone Safari or a Hotwire Native web view.

## [0.59.0] - 2026-11-03

### Changed
- On a phone, a `ui_mobile_header` title and subtitle sit in the top bar's row between the Back arrow, or the bar's left edge, and the right-side controls, and start at the left of that space. They are no longer centred on the bar, so the controls can no longer cover them. A title or subtitle too long for the space ends in an ellipsis.
- A `ui_mobile_header` with a subtitle makes the top bar 40px tall inside its padding when the bar's other contents are shorter than that, since the title and subtitle now count toward the bar's height.
- In `ui_navbar`, right-side controls that leave less than 6rem for a `ui_mobile_header` title move to a second row under the title, so the bar is taller on those pages. Controls wider than the bar wrap onto more rows, aligned to the right. Pages with no `ui_mobile_header`, and every width from `lg:` up, are unchanged.

### Host action
- A host with its own top bar needs no change if its `ui_mobile_header` is a direct child of a flex row, as in a `.top-nav` bar. A host wrapping the header in another element must make that element `flex` with `min-w-0 flex-1`.
- A hand-written bar whose right-side controls can fill the width adds `max-lg:has-[.ks-mobile-header-title]:flex-wrap` to its `<nav>` to get the second row. Without it nothing overlaps, but the title can shrink until almost none of it shows.

## [0.58.0] - 2026-11-03

### Added
- `ui_mobile_action` draws the main action a screen publishes as a plus icon link in a host's top bar, on phones only. It draws nothing when the screen publishes no action, and it is hidden from `sm:` up, inside a Hotwire Native web view and when the page is printed.
- `ui_hero` takes `height:`. `height: :content` draws the hero only as tall as its content and its padding, and the default `height: :screen` keeps it at least the full screen height. Any other value raises `ArgumentError`.
- `ui_navbar` takes `hide_logo_on_mobile: true`, for a page that shows its own title in the phone header. The `logo` slot is hidden below `lg:` and still shows from `lg:` up. The default, `false`, keeps the logo at every width.

### Changed
- `ui_page_header` with `action_url:` and no `header.action` block draws a button to that address with `action_label:`. A `header.action` block is still drawn alone when both are given.
- A `ui_form_field` checkbox has its words as a label tied to its box through an id built from `attribute:`, so tapping the words ticks and unticks the box and a screen reader reads them as its label.

## [0.57.0] - 2026-11-02

### Changed
- An action menu with no room under its button opens above it, and at the top of the screen when it fits neither under nor above its button.
- An open action menu stays open while the page scrolls and moves with its button, instead of closing.
- An open action menu closes when a tap or click is released outside it, which an iPhone web view sends for a tap on plain page content.
- `ui_mobile_actions` uses the `action-menu` Stimulus controller, so it opens, moves and closes as `ui_action_menu` does, and its markup carries `data-action-menu-target` in place of `data-dropdown-target`.

## [0.56.0] - 2026-10-31

### Added
- `ui_form_field` and `ui_input` take `autofocus:`, `autocomplete:`, `autocapitalize:` and `inputmode:`, and write each one given onto the input.
- `ui_input` takes `required: true` to stop the form sending while the input is empty.

### Changed
- A `ui_form_field` label is tied to its input, textarea or select through an id built from `attribute:`.
- A `ui_form_field` with `required: true` also sets the `required` attribute on its input, so the browser will not send the form while it is empty.

## [0.55.0] - 2026-10-30

### Changed
- Requires keystone_ui-styles 0.28.0 or later, which colours the row `ui_data_table` marks with `current_row:`.

### Added
- `ui_data_table` takes `current_row:`, and the first row equal to that item gets the `ks-table-row-current` class and `aria-current="true"`.

## [0.54.0] - 2026-10-30

### Added
- `ui_button` takes `method:` with `href:`, and a POST, PATCH or DELETE button sends that request from its own small form when tapped.
- `ui_button` takes `full_width: true` to make the button, and the form of a button sending a request, as wide as its row.
- `ui_picture` shows an image no taller than half the screen, with `alt:` text.
- `ui_picture` takes `full_size_url:` to open the full-size file in a new tab when the picture is tapped.

## [0.53.0] - 2026-10-29

### Changed
- Requires keystone_ui-styles 0.27.0 or later, which draws the match `ui_search_select`'s arrow keys highlight.

### Added
- `ui_search_select` draws a form field that lists the host app's matches as a person types, from `GET url?q=`, and submits the id of the one they pick.
- `ui_search_select` takes `selected_id:` and `selected_label:` to open with a record already chosen.
- `ui_search_select` takes `new_label:` and a block, and choosing that last option clears the id and shows the block's fields for a new record.
- The arrow keys move through `ui_search_select`'s matches, Enter picks one, and Escape closes the list.

## [0.52.0] - 2026-10-22

### Changed
- `ui_theme_toggle` is one button showing a sun in light mode and a moon in dark mode, which switches to the other mode when pressed, in place of the Light, Dark and System buttons.
- A visitor who has never pressed the toggle still sees the mode their device is set to, and the toggle shows the sun or the moon to match.
- `Keystone::Ui::ThemeToggleComponent` takes no `current:` argument and no longer has `options` or `pressed?`.

## [0.51.0] - 2026-10-21

### Added
- `ui_form_field` and `ui_input` take `type: :datetime`, which renders a `datetime-local` input, and a `Time` or `DateTime` given as `value:` is written as `YYYY-MM-DDTHH:MM` while a string is used as given.

## [0.50.1] - 2026-10-20

### Fixed
- An app using keystone_ui boots with view_component 4.17, which failed with `undefined method 'gsub' for an instance of Pathname` because the engine added its components folder to the autoload paths as a path object instead of text.

## [0.50.0] - 2026-10-16

### Fixed
- `ui_bar_chart` keeps its labels at the page's small text size and grows no taller than it is in an 800px-wide column, so a chart on a wide page spreads its bars across the width instead of growing tall with large text.
- `ui_bar_chart` labels no step above the top of its value axis.

## [0.49.0] - 2026-10-15

### Added
- `ui_stat_card` takes `note:` to show a short note under its value, `plain: true` to draw a plain figure with no card border or background, and `fallback:` to show muted text such as "N/A" when its value is missing, and a stat card given none of them looks as it did.

## [0.48.0] - 2026-10-15

### Changed
- `ui_navbar`, `ui_navigation`'s top bar and sidebar, `ui_bottom_nav`, `ui_mobile_header`, `ui_mobile_actions`, `ui_breadcrumbs` and the desktop back link are left off a printed page, so a page prints with its content only.

## [0.47.0] - 2026-10-15

### Changed
- `ui_line_chart` redraws in the new colours when a script sets theme variables on the page's root element.
- `ui_line_chart` draws in the light or dark of the nearest element around it with a `data-theme` attribute, so a chart inside a dark panel on a light page draws dark.

## [0.46.0] - 2026-10-15

### Added
- `ui_bar_chart(bars:, show_values: false)` draws a bar chart on the server as an SVG, with a value axis in round steps and a grid line at each, each bar's label under it, a faded bar for one marked `shaded: true`, and each bar's value on it when `show_values: true`.

### Changed
- keystone_ui requires keystone_ui-styles 0.22.0 or later, which defines the bar chart classes.

## [0.45.0] - 2026-10-15

### Added
- `Keystone::Ui::Column` takes `align: :start` or `align: :end` to align a column's heading and cells left or right, and a column given no alignment keeps the table's own.
- `ui_data_table` takes `group_by:` to list rows under heading rows named by a value in each row, and `group_totals:` to show each group's subtotals under their columns in its heading row.
- `ui_data_table` takes `total:` to end the table with a total row showing the values given under their columns.

## [0.44.0] - 2026-10-15

### Added
- `ui_value_list(rows:, align: :start)` shows rows of a label and its value, each with an optional note under the label, an optional total marking and optional fallback text shown when the value is missing, and `align: :end` pushes each value to the right end of its row.

### Changed
- keystone_ui requires keystone_ui-styles 0.20.0 or later, which defines the value list classes.

## [0.43.0] - 2026-10-15

### Changed
- `ui_color_picker` shows its value in a text field in place of the hex label, and a colour typed there as hex, `rgb()`, `hsl()` or `oklch()` is drawn in the swatch and submitted exactly as typed.
- `ui_color_picker` ignores a typed colour the browser cannot read, so the swatch and the submitted value keep the last colour it could.
- `ui_color_picker` still submits six-digit hex for a colour chosen in the hue panel, and moves the hue panel to a typed six-digit hex colour.

## [0.42.0] - 2026-10-15

### Added
- `ui_heading(text:, size: :md, note: nil)` shows a heading small, medium or large, with an optional short note at the right end of its row.
- `ui_caption(text:)` shows small, uppercase, muted text for placing above a title or a figure.
- `ui_paragraph(text:)` shows a paragraph of running text.

### Changed
- keystone_ui requires keystone_ui-styles 0.17.0 or later, which defines the theme's five chart colours and their dark-mode versions.
- keystone_ui requires keystone_ui-styles 0.19.0 or later, which defines the heading, caption and paragraph classes.
- `ui_line_chart` draws a series with no colour of its own in the next of the theme's five chart colours, in order, and keeps a colour its caller gives it.
- `ui_line_chart` draws thin lines with no dot on each data point, and shows a dot in the line's colour on a data point only while the cursor is over it.
- `ui_line_chart` draws only horizontal grid lines, in the theme's border colour.
- `ui_line_chart` draws its axis text small, in the theme's muted text colour and the app's body font, or the font the chart inherits when the body font is left to inherit.
- `ui_line_chart` draws its tooltip in the theme's surface, border and text colours.
- `ui_line_chart` draws each line in from left to right when it first appears, and appears without animating for someone who prefers reduced motion.
- `ui_line_chart` redraws in the new colours when dark mode, the look or the palette changes, without a page reload.

## [0.41.0] - 2026-10-13

### Changed
- keystone_ui requires keystone_ui-styles 0.16.0 or later, which draws a border around an open sidebar group's tabs and lines between the links in a group and in a dropdown menu.

### Added
- `config.navigation_tab` declares a tab outside any group, which `ui_navigation` draws as a plain link in the top bar and as a plain tab with no group label in the sidebar, marked active on its own page in both.
- The sidebar drawn by `ui_navigation` holds each group's tabs inside one element with the class `ks-sidebar-group-tabs`, so keystone_ui-styles can draw a border around an open group's tabs and lines between them, and a tab declared outside any group is not inside one.

## [0.40.0] - 2026-10-10

### Changed
- keystone_ui requires keystone_ui-styles 0.15.0 or later, which styles the sidebar's logo, tabs and collapsing group labels.

### Added
- Each group in the sidebar drawn by `ui_navigation` shows only its label until it is clicked, and clicking the label opens or closes its tabs without reloading the page, using the browser's own disclosure element so it needs no script. The group holding the current page's tab is open when the page loads.
- The sidebar drawn by `ui_navigation` wraps the logo in an element with the class `ks-sidebar-logo`, so keystone_ui-styles can give the logo its own spacing and remove its underline.

### Fixed
- A menu in the sidebar drawn by `ui_navigation` opens in place below its button inside the sidebar, instead of as a dropdown cut off by the sidebar's edge, including a menu whose panel the app positions absolutely in its own stylesheet. The sidebar is as wide as its widest item, closed menu items included, so opening or closing a menu does not change its width. Menus in the top bar still open as dropdowns.
- At the top placement, `ui_navigation` hands the layout its top bar and the page content inside one element, as it already did for a sidebar, so in a body laid out as a grid of header, stretching row and footer a short page shows its content directly under the top bar.

## [0.39.0] - 2026-10-10

### Changed
- The `keystone_ui-develop` local can run commands in the host app, so it can run the app's tests, linter and git as the app's own process requires.

### Added
- The app refuses to start when its navigation declaration has a tab with no label or no link, two tabs sharing a key, or a group with no tabs, and the error names the tab, the key or the group.

## [0.38.0] - 2026-10-10

### Added
- `ui_navigation` draws the tabs an app declares with `config.navigation_group` as a top bar of menus on desktop screens, above the page content a layout passes it, leaving out tabs whose permission check fails and groups with no tab left.
- A layout can hand `ui_navigation` a logo, drawn at the left end of its top bar, and menus such as an account menu and a user menu, drawn at its right end.
- `ui_navigation` draws a sidebar on the left or the right of the page content on desktop screens when the preference supplied for `:navigation` names that placement, showing each group's label above its tabs, the logo at its top and the menus at its bottom, and draws the top bar for any other placement.
- `config.current_tab_supplier` lets an app name the declared tab the current page belongs to, and `ui_navigation` shows that tab and its group as active in the top bar and the sidebar.
- `ui_navigation` draws its groups and each group's tabs in the order saved under `"order"` in the preference supplied for `:navigation`, naming groups by label and tabs by key, with unnamed ones after in declared order and names no longer declared ignored.

### Changed
- Requires keystone_ui-styles 0.14.0 or later, which styles the navigation sidebar.

## [0.37.0] - 2026-10-07

### Added
- A data table's Columns menu says when a change was not saved, puts its boxes and order back to what the table shows, and does not reload the page.

### Fixed
- A data table treats a saved layout that is not a hash, or a hidden list or column order that is not a list, as nothing saved, instead of raising an error or reading text as a column name.

### Changed
- A data table and its Columns menu read a saved layout through one shared `Keystone::Ui::SavedLayout`, so they always agree on which columns are hidden and in what order. `ui_column_picker` still takes `hidden_columns:`.

## [0.36.0] - 2026-10-07

### Added
- `Keystone::Ui::Column` takes `locked: true`, which keeps a data table's first column in view while the rest of the table scrolls sideways, and leaves it out of the Columns menu so it cannot be hidden or moved.

## [0.35.0] - 2026-10-07

### Changed
- A data table's Columns menu saves once when it closes, instead of after every tick or move, and greys an unticked column's name straight away.
- A data table shows its Columns menu in a row above itself, aligned right.
- A form or show page with a trail shows its "Back" link above its breadcrumbs instead of replacing it with them.
- The desktop "Back" link and the breadcrumbs leave space between themselves and the page content, with the Back link kept close above the breadcrumbs. This needs keystone_ui-styles 0.12.0 or later.

### Added
- A form or show page given an empty trail is a nav tab's own page and shows no "Back" link and no breadcrumbs.
- `ui_mobile_header` given a `nil` `back_url:` shows no back arrow.

## [0.34.0] - 2026-10-06

### Added
- A data table renders its hideable columns in the order a saved `"column_order"` names, and its Columns menu gives each column up and down buttons that save the new order with the hidden columns.

## [0.33.1] - 2026-10-06

### Fixed
- A data table given a key keeps the columns its own call hides when the supplied value is `nil` or names no hidden columns, so a person with nothing saved still sees the default layout and the Columns menu.

## [0.33.0] - 2026-10-06

### Added
- `ui_data_table` takes `key:` to find its saved layout through `config.preference_supplier`, hiding the columns the saved value names and showing a Columns menu above itself when the supplier gives a save address.

## [0.32.0] - 2026-10-06

### Added
- `ui_figure(text:, tone:)` shows a figure in plain text, or in the success or danger colour, so an amount can read as gain or loss without a badge around it.

### Fixed
- A data table's last column header is right-aligned like the cells beneath it, so a figure placed in that header lines up with the figures below.
- The info button sits level with the text beside it instead of above it.

## [0.31.0] - 2026-10-06

### Added
- `ui_funnel` takes `shape: :joined` to draw one joined shape: each step's value and label on the left, each block at its share of the first step, and a neutral band between two blocks holding the percent from one to the next.

## [0.30.0] - 2026-10-02

### Added
- `ui_line_chart(dates:)` takes dates in place of `labels:` and spaces its points by the days between them, on an axis that runs from the first day to the last and reads each day as a date.

### Changed
- `ui_line_chart` raises `ArgumentError` when it is given both `labels:` and `dates:`, or neither.

## [0.29.5] - 2026-10-01

### Fixed

- An info button's popup opens just under the button on the first hover or click, because the button is now measured after the popup has left the page's layout rather than before.

## [0.29.4] - 2026-10-01

### Fixed

- An info button's popup opens just under the button the first time, instead of in the middle of the screen.
- An info button's popups wrap their text inside a table and never grow wider than the screen.
- A breakdown sets its lines out as an equation, with its total below a rule, through keystone_ui-styles 0.9.0, which keystone_ui now requires.

## [0.29.3] - 2026-10-01

### Fixed

- A page with no line chart no longer downloads the charting script, which now loads when a chart appears on the page.

## [0.29.2] - 2026-10-01

### Fixed

- An info button's summary and detail open at a fixed spot on the screen under the button, so a table no longer cuts them off, and a click elsewhere or a scroll closes them.

## [0.29.1] - 2026-10-01

### Fixed

- A data table given a database query runs it once, instead of once to check whether it is empty and again to draw its rows.

## [0.29.0] - 2026-10-01

### Added
- `ui_info(summary:)` shows an info button anywhere: its summary shows on hover, and clicking opens whatever it is given.
- `ui_breakdown(lines:, total:)` lists each amount beside what it is and ends with the total.

## [0.28.0] - 2026-10-01

### Added
- `ui_form_field` takes `suggestions:`, offered while the field's text is typed through the browser's own suggestion list.

## [0.27.0] - 2026-09-30

### Added
- `ui_radio_card` and `ui_checkbox_row` take `info:`, shown in a panel behind an info button beside the label that opens on hover and toggles on tap.

### Changed
- keystone_ui requires keystone_ui-styles 0.8.0 or later, which styles the info button and panel.

## [0.26.0] - 2026-09-30

### Added
- `ui_action_menu_item` takes `confirm:`, a question asked before the item runs.

### Changed
- An action menu item that deletes asks for confirmation before it runs, unless it is given its own question.

## [0.25.0] - 2026-09-30

### Fixed
- A table row whose actions are empty shows no action menu.
- An action menu opens on top of the page under its button, so a table or any other box that hides what overflows it no longer cuts the menu off. An open menu closes when the page scrolls or resizes.

## [0.24.0] - 2026-09-30

### Added
- `ui_action_menu` renders an ellipsis button that opens a dropdown of actions at every screen size, and `ui_action_menu_item(label:, href:, method:)` renders one entry as a link or as a button sending its method.
- `ui_section` takes `menu:`, a list of items shown in an action menu in the section's header.

### Changed
- `ui_data_table` puts each row's actions in an action menu, so a table shows no buttons. Row actions should be `ui_action_menu_item` calls.

## [0.23.0] - 2026-09-29

### Added
- `ui_form_page` and `ui_show_page` raise `KeystoneUi::MissingBackLink`, naming the page, when they get no Back link from `back_url:`, `trail:` or the trail supplier.
- `ui_form_page` and `ui_show_page` raise `KeystoneUi::IncompleteTrail`, naming the page, when a link in their trail has no label or no address.

## [0.22.0] - 2026-09-29

### Added
- `config.trail_supplier` lets an app supply the breadcrumb trail for any `ui_form_page` or `ui_show_page` that passes no `trail:`.
- `back_url:` on `ui_form_page` and `ui_show_page` is optional, and defaults to the last link of the trail.

## [0.21.1] - 2026-09-29

### Fixed
- The desktop back link, the breadcrumbs and the form page title show at the top of the page's `ui_page`, inside its width and padding, instead of against the edge of the screen.

## [0.21.0] - 2026-09-29

### Added
- `ui_form_page` and `ui_show_page` show a link back to `back_url` on `lg` screens and wider, where the mobile header and its back link are hidden.
- `ui_breadcrumbs` shows the pages above the current one as links on `lg` screens and wider.
- `ui_form_page` and `ui_show_page` take an optional `trail:`, and show breadcrumbs ending with their title in place of the desktop back link when given one.

## [0.20.0] - 2026-09-28

### Added
- A Turbo visit carries the next page's `data-look` onto the page, and removes it when the next page has none, so a look changes without a full reload.
- Boot stops with an error naming the look when a registered look's file is missing or sets no `--ks-` variables under its name, and when the default look is not registered.

## [0.19.0] - 2026-09-28

### Added
- `ui_calculation` shows the working behind a figure, grouped into lines of a label, the working and the result, closed by default under a quiet "How this is worked out" row.

## [0.18.0] - 2026-09-28

### Added
- A host can register several looks by name, each with its CSS file, and name one as the default. `keystone_source.css` imports them, and `keystone_theme_attributes` marks the `html` tag with `data-look`.
- A gem can choose a page's look through `look_supplier`, and a name that is not registered leaves the page on the default look.

## [0.17.0] - 2026-09-28

### Added
- A host or a gem can restyle every button from one look file that sets keystone_ui-styles' `--ks-` variables, and the README shows a complete one.
- The test suite fails, naming the component and the utility, when a component constant holds a colour, radius, weight, shadow, border or spacing utility.

### Changed
- The modal, mobile action menu, column picker, multi select, copy button, theme toggle, checkbox row, radio card, option card, file upload, colour picker and panel render keystone_ui-styles' `ks-` classes for how they look, so a look file restyles them. They look the same until a variable is set.
- The file upload's drop zone marks itself active with one class while a file is dragged over it.
- The stat card, chart card, card link, call to action banner, feature grid, hero, data table, code, accordion, disclosure, tab switcher, progress, funnel, bucket, pipeline and swipe deck render keystone_ui-styles' `ks-` classes for how they look, so a look file restyles them. They look the same until a variable is set.
- The funnel's step colours and the bucket's over-goal fills are classes a look file can recolour.
- The navbar title, nav items, nav dropdown, bottom nav, mobile header and settings link render keystone_ui-styles' `ks-` classes, so a look file restyles them, and they have visible colours in a host that sets no variables.
- keystone_ui no longer ships its own nav stylesheet or its `bottom-nav`, `nav-dropdown` and related class names, which are now `ks-bottom-nav`, `ks-nav-dropdown` and so on.
- The grid's gaps, form and form field spacing, the theme toggle's gap, the form page and show page titles and subtitles, the colour picker's label and the settings link's arrow render keystone_ui-styles' `ks-` classes, so a look file restyles them.
- keystone_ui requires keystone_ui-styles 0.6.0 or later.

### Upgrading
- A host that coloured its nav with the `--base-bg-low`, `--base-bg-base`, `--base-bg-hover`, `--base-border-tertiary`, `--base-text`, `--base-text-secondary`, `--base-text-tertiary`, `--text-primary` or `--border-primary` variables keeps those colours, because the new nav colours read them first. The look variables that replace them are `--ks-color-nav`, `--ks-color-nav-menu-mobile`, `--ks-color-nav-hover`, `--ks-color-nav-border`, `--ks-color-nav-link`, `--ks-color-nav-text-hover`, `--ks-color-nav-text`, `--ks-color-nav-active` and `--ks-color-nav-indicator`, in that order.
- A host stylesheet that targeted the old `bottom-nav` or `nav-dropdown` class names needs the `ks-` names instead.

## [0.16.0] - 2026-09-26

### Added
- A form field can be disabled with `disabled: true`, so its input shows a value that cannot be typed over and is not submitted with the form.

## [0.15.1] - 2026-09-24

### Fixed
- A page keeps the theme of the page Turbo shows next, where before it kept the theme of the first page loaded.

### Changed
- A bucket refuses a goal or amount that is not a number with an error naming the value, where before a string such as "9,000" failed with an unrelated error.

## [0.15.0] - 2026-09-24

### Added
- A form field's select can word its empty choice with `include_blank:`.

## [0.14.0] - 2026-09-24

### Added
- A gem can supply custom as the theme mode, and the page is marked custom.

### Changed
- Requires keystone_ui-styles 0.3.0 or later, which draws a page marked custom.

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
