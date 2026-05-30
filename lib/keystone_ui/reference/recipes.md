## Page Recipes

How to compose Keystone UI helpers for common page scenarios. Build pages by
nesting these helpers — never hand-write HTML or Tailwind. All examples are
mobile-first.

### Index page (list of records)

`ui_page` → `ui_page_header` (with an action) → `ui_data_table`.

```erb
<%= ui_page(max_width: :lg) do %>
  <%= ui_page_header(title: "Products") do |header| %>
    <% header.action do %>
      <%= ui_button(label: "Create", href: new_product_path) %>
    <% end %>
  <% end %>

  <%= ui_data_table(items: @products, columns: [
        { name: "Name" },
        { price: "Price" },
        { created_at: "Added" }
      ], empty_message: "No products yet.") do |table| %>
    <% table.link(:name) { |product| product_path(product) } %>
    <% table.actions do |product| %>
      <%= link_to "Edit", edit_product_path(product) %>
    <% end %>
  <% end %>
<% end %>
```

Use `Keystone::Ui::Column` objects instead of `{ key: "Label" }` hashes when you
need per-column options (e.g. `mobile_hidden: true` to drop a column on phones).

### Form page (new / edit)

`ui_form_page` (title + back navigation) → `ui_form` → `ui_form_field`s →
submit `ui_button`. Use `method: :patch` and the record path when editing.

```erb
<%= ui_form_page(title: "New Product", back_url: products_path) %>

<%= ui_form(action: products_path) do %>
  <%= ui_form_field(attribute: :name, required: true) %>
  <%= ui_form_field(attribute: :price, type: :number, hint: "In dollars") %>
  <%= ui_button(label: "Save", type: :submit) %>
<% end %>
```

Editing an existing record:

```erb
<%= ui_form_page(title: "Edit Product", back_url: product_path(@product)) %>

<%= ui_form(action: product_path(@product), method: :patch) do %>
  <%= ui_form_field(attribute: :name, value: @product.name, required: true) %>
  <%= ui_button(label: "Save", type: :submit) %>
<% end %>
```

For file uploads add `multipart: true` to `ui_form` and use `ui_file_upload`.

### Show / detail page

`ui_show_page` (title + back) → `ui_section`/`ui_panel` for content →
`ui_mobile_actions` for the mobile action menu.

```erb
<%= ui_show_page(title: @product.name, back_url: products_path, subtitle: "Details") %>

<%= ui_page(max_width: :md) do %>
  <%= ui_panel do %>
    <p><%= @product.description %></p>
    <%= ui_badge(label: @product.status, variant: :success) %>
  <% end %>

  <%= ui_mobile_actions do %>
    <%= link_to "Edit", edit_product_path(@product) %>
    <%= link_to "Delete", product_path(@product), data: { turbo_method: :delete } %>
  <% end %>
<% end %>
```

### Dashboard

`ui_page` → `ui_grid` of `ui_stat_card`s → `ui_chart_card` for charts.

```erb
<%= ui_page(max_width: :xl) do %>
  <%= ui_grid(cols: { default: 1, sm: 2, lg: 4 }, gap: :lg) do %>
    <%= ui_stat_card(label: "Revenue", value: "$42,300", variant: :success, suffix: "/mo") %>
    <%= ui_stat_card(label: "Orders", value: "1,204") %>
    <%= ui_stat_card(label: "Refunds", value: "12", variant: :danger) %>
    <%= ui_stat_card(label: "Signups", value: "318", variant: :info) %>
  <% end %>

  <%= ui_chart_card(title: "Monthly Revenue", height: :lg) do %>
    <!-- chart content -->
  <% end %>
<% end %>
```

### Settings page

`ui_page` → `ui_section`s grouping related fields → `ui_form` with
`ui_form_field` / `ui_select` / `ui_option_card`. Link to it with
`ui_settings_link` in the navbar.

```erb
<%= ui_page(max_width: :md) do %>
  <%= ui_section(title: "Profile", subtitle: "Your account details") do %>
    <%= ui_form(action: settings_path, method: :patch) do %>
      <%= ui_form_field(attribute: :name, value: @user.name) %>
      <%= ui_select(name: "user[timezone]", options: @timezones, selected: @user.timezone) %>
      <%= ui_button(label: "Save", type: :submit) %>
    <% end %>
  <% end %>

  <%= ui_section(title: "Appearance") do %>
    <%= ui_option_card(name: "theme", value: "dark", selected: true) do %>
      Dark Mode
    <% end %>
  <% end %>
<% end %>
```
