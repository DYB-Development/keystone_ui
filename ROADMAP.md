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

## Planned: Schema Layer & Auto Pages

### Goal

Given a description of a resource (e.g. `Contact` with its fields), have
Keystone auto-generate `new`/`edit`/`show`/`index` pages without writing
per-resource ERB.

The description must be a plain Ruby data structure — **not** an ActiveRecord
model — so Keystone stays decoupled from Rails persistence.

### Current coupling assessment

Keystone is already largely decoupled. Verified by reading the source:

| Component | Coupling to AR? | Notes |
|---|---|---|
| `FormComponent` | None | Takes `action:` URL string + `method:` symbol. |
| `FormFieldComponent` | None | Plain kwargs: `attribute`, `type`, `value`, `errors`, `options`. |
| `InputComponent` / `TextareaComponent` / `SelectComponent` | None | Pure HTML primitives. |
| `DataTableComponent` | None — duck-typed | `resolve_value` does `item.respond_to?(key) ? item.public_send(key) : item[key]`. Works with AR, Hash, Struct, OpenStruct. |
| `Column` | None | Pure value object. |
| gemspec | `view_component` only | No `activerecord` / `activemodel` dependency. |

**Conclusion:** there is no decoupling work to do at the component layer. The
work is to add a layer *above* the components.

### What's missing — the "Schema" layer

A small set of plain Ruby objects that describe a resource's fields.
Components already accept the right shape; we just need a builder + a renderer
that loops fields and calls the existing helpers.

#### Proposed objects (all under `Keystone::Ui`)

```ruby
Keystone::Ui::Field.new(
  name: :email,
  type: :email,          # :text :email :password :date :number :textarea :select :checkbox
  label: "Email",        # optional, defaults to humanized name
  required: true,
  hint: "Used for login",
  placeholder: nil,
  options: [],           # for :select
  min: nil, max: nil, step: nil,
  show_in: %i[form show index],  # which auto-views include it
)

Keystone::Ui::Schema.new(
  resource_name: :contact,
  fields: [ ... ],
  index_columns: %i[name email phone],  # optional override
  sortable: %i[name email],
)
```

#### Proposed components (new)

- `AutoFormComponent(schema:, record:, action:, method:, errors: {})`
  Loops `schema.form_fields`, pulls `record.public_send(field.name)` if record
  responds, otherwise `record[field.name]`, otherwise `nil`. Uses existing
  `FormFieldComponent` for each field. Wraps in existing `FormComponent`.

- `AutoShowComponent(schema:, record:)`
  Renders a definition list of `field.label` → resolved value, using existing
  `PanelComponent` / `SectionComponent`.

- `AutoTableComponent(schema:, items:, sort:, sort_direction:, sort_url:)`
  Builds `Column` objects from `schema.index_columns` and hands off to
  existing `DataTableComponent`.

#### Schema DSL (sugar)

```ruby
ContactSchema = Keystone::Ui::Schema.define(:contact) do
  field :name,  :text,  required: true
  field :email, :email, required: true, hint: "Used for login"
  field :phone, :text
  field :notes, :textarea, show_in: %i[form show]
  index_columns :name, :email, :phone
end
```

### How host apps stay decoupled — decided

The gem **never** imports or reflects on ActiveRecord.

**Decision (v1):** schemas live in standalone constants under `app/schemas/`:

```ruby
# app/schemas/contact_schema.rb
ContactSchema = Keystone::Ui::Schema.define(:contact) do
  field :name, :text, required: true
  ...
end
```

This keeps UI concerns out of the model and works identically for non-AR
resources (PORO, API client, Redis-backed object).

**Decision (v1.x):** ship `keystone_ui-active_record` as a **separate gem**
with its own gemspec. It inspects `columns_hash` and `validators_on(:attr)` to
produce a default schema that the host can override. Lives in its own repo so
the core stays AR-free. Not built until core v1 ships and someone asks for it.

The "class method on the model" pattern is not blocked — hosts can do it
themselves — but isn't a documented convention.

### Trade-offs / open questions

- **Errors shape.** `FormFieldComponent` takes `errors:` as an array of
  strings. AutoForm needs an `errors` hash keyed by field. Host passes
  `record.errors.messages` for AR, plain hash otherwise. Document this.
- **Value coercion / display formatting.** Show pages often want formatted
  values (dates, currency). Add `format:` to `Field` taking a Proc, or a
  `display_with:` lambda. Don't bake in `Rails.application.routes` or
  `number_to_currency`.
- **Nested / has_many.** **Decided: out of scope for v1.** Flat fields only:
  `text`, `email`, `password`, `date`, `number`, `textarea`, `select`,
  `checkbox`, `file`. Matches what `FormFieldComponent` already supports.
  Nested/has_many is a v2 conversation.
- **File uploads.** `FileUploadComponent` exists — `:file` field type maps to
  it.
- **Type registry.** Should `field :status, :select, options: [...]` be
  extensible? Add a `Keystone::Ui::FieldTypes` registry so apps can register
  custom field types that map to a component.
- **Strong params.** The gem doesn't need to know. Host controller permits
  `schema.field_names`.

### Build order (TDD, one commit per step)

Per the project rule of one test/one commit, this naturally splits into ~15
commits:

1. `Keystone::Ui::Field` value object + spec (name/type defaults).
2. `Field#label` humanization.
3. `Field#show_in?` filter.
4. `Keystone::Ui::Schema` constructor + `#fields` spec.
5. `Schema#form_fields` / `#show_fields` / `#index_columns`.
6. `Schema.define` DSL — basic `field` macro.
7. `Schema.define` — `index_columns` macro.
8. `AutoFormComponent` — renders one text field.
9. `AutoFormComponent` — multiple field types.
10. `AutoFormComponent` — errors lookup by field name.
11. `AutoShowComponent` — label/value rows.
12. `AutoShowComponent` — `format:` lambda.
13. `AutoTableComponent` — builds columns from schema.
14. `AutoTableComponent` — sortable passthrough.
15. Helpers: `ui_auto_form`, `ui_auto_show`, `ui_auto_table`.
16. README + ROADMAP entries.

### What this is NOT

- Not a scaffolding generator. No files are created at install time.
- Not an admin framework like ActiveAdmin. No auth, no policies, no nested
  resources — that's the host's job.
- Not coupled to AR. AR adapter (if built) ships as a separate gem.

### End-to-end wiring example — `Contact`

What a consuming app actually writes once the gem is built.

#### Model — unchanged, no Keystone awareness

```ruby
# app/models/contact.rb
class Contact < ApplicationRecord
  validates :name, :email, presence: true
  validates :email, uniqueness: true
end
```

#### Schema — the one new file per resource

```ruby
# app/schemas/contact_schema.rb
ContactSchema = Keystone::Ui::Schema.define(:contact) do
  field :name,    :text,     required: true
  field :email,   :email,    required: true, hint: "Used for login"
  field :phone,   :text
  field :status,  :select,   options: %w[active archived prospect]
  field :notes,   :textarea, show_in: %i[form show]   # skipped on index

  index_columns :name, :email, :status
  sortable      :name, :email
end
```

#### Routes — standard Rails

```ruby
# config/routes.rb
resources :contacts
```

#### Controller — thin, no Keystone-specific code

```ruby
# app/controllers/contacts_controller.rb
class ContactsController < ApplicationController
  before_action :set_contact, only: %i[show edit update destroy]

  def index
    @contacts = Contact.order(sort_column => sort_dir)
  end

  def show; end
  def new;  @contact = Contact.new; end
  def edit; end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to @contact, notice: "Created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @contact.update(contact_params)
      redirect_to @contact, notice: "Saved"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_contact = @contact = Contact.find(params[:id])
  def contact_params
    params.require(:contact).permit(*ContactSchema.field_names)   # ← only Keystone touch
  end

  def sort_column = ContactSchema.sortable?(params[:sort]) ? params[:sort] : :name
  def sort_dir    = %w[asc desc].include?(params[:dir]) ? params[:dir] : :asc
end
```

The only Keystone-aware line is `ContactSchema.field_names` for strong params.

#### Views — each is 3–5 lines

```erb
<%# app/views/contacts/new.html.erb %>
<%= ui_form_page title: "New contact", back_url: contacts_path do %>
  <%= ui_auto_form schema: ContactSchema,
                   record: @contact,
                   action: contacts_path,
                   method: :post %>
<% end %>
```

```erb
<%# app/views/contacts/edit.html.erb %>
<%= ui_form_page title: "Edit contact", back_url: contact_path(@contact) do %>
  <%= ui_auto_form schema: ContactSchema,
                   record: @contact,
                   action: contact_path(@contact),
                   method: :patch %>
<% end %>
```

```erb
<%# app/views/contacts/show.html.erb %>
<%= ui_show_page title: @contact.name, back_url: contacts_path do %>
  <%= ui_auto_show schema: ContactSchema, record: @contact %>
<% end %>
```

```erb
<%# app/views/contacts/index.html.erb %>
<%= ui_page do %>
  <%= ui_page_header title: "Contacts" do %>
    <%= ui_button href: new_contact_path, label: "Create" %>
  <% end %>
  <%= ui_auto_table schema:         ContactSchema,
                    items:          @contacts,
                    sort:           params[:sort],
                    sort_direction: params[:dir],
                    sort_url:       ->(key, dir) { contacts_path(sort: key, dir: dir) } %>
<% end %>
```

No per-field ERB anywhere. Adding a column to `Contact` is a one-line schema
change; all four pages pick it up.

#### "Out of the box" — honest accounting

| File | Hand-written? | Size |
|---|---|---|
| Model | Yes (unchanged) | normal AR |
| Schema | Yes — the one new file per resource | 8–15 lines |
| Routes | Yes | 1 line |
| Controller | Yes | ~30 lines (standard CRUD) |
| 4 view files | Yes | 3–5 lines each |

Total per resource: **one schema file + standard Rails CRUD + ~20 lines of
ERB**.

### Can the controller be skipped?

Honest answer: **you can avoid writing a per-resource controller file, but
every option has trade-offs.** Three points on the spectrum:

#### Option A — Hand-rolled controller (shown above)

- ~30 lines per resource.
- Maximum flexibility: per-action auth, scoping, callbacks, custom params.
- Recommended default.

#### Option B — Controller concern (recommended sugar, v1.x)

Ship `Keystone::Resources::Controller` as a concern. Each controller becomes:

```ruby
class ContactsController < ApplicationController
  include Keystone::Resources::Controller
  keystone_resource Contact, schema: ContactSchema
end
```

The concern provides default `index/show/new/create/edit/update/destroy` using
the schema for sorting + strong params. Hosts override any action they need
to customize:

```ruby
class ContactsController < ApplicationController
  include Keystone::Resources::Controller
  keystone_resource Contact, schema: ContactSchema

  before_action :authenticate_user!

  private

  def collection_scope = current_user.contacts   # override default Contact.all
end
```

Trade-off: still one controller file per resource, but only 2–3 lines unless
you customize. **This is the sweet spot for most apps.**

#### Option C — Single generic controller + registry (NOT recommended)

```ruby
# config/initializers/keystone_resources.rb
Keystone::Ui.register_resource(:contacts, model: Contact, schema: ContactSchema)
Keystone::Ui.register_resource(:companies, model: Company, schema: CompanySchema)
```

One `Keystone::ResourcesController` reads `params[:resource]` and dispatches.
Routes via `resources :keystone_resources, path: ":resource"`.

Trade-offs:
- Per-resource auth becomes a switch statement or a registry callback hash.
- Per-resource scoping (`current_user.contacts` vs `Company.all`) needs
  another registry hook.
- Strong params hook needs another registry entry.
- You end up rebuilding ActiveAdmin / Administrate / Avo.

By the time you've added all the hooks the registry needs, you've written
more config than Option B would have cost. Not worth it unless the goal is an
admin framework — in which case use ActiveAdmin.

#### Recommendation

- **v1:** ship Auto components only. Users write Option A controllers.
- **v1.x:** add Option B concern as opt-in sugar.
- **Skip Option C.** If a host wants that, point them at ActiveAdmin.

### Turbo Frames / Turbo Streams

Less tricky than it looks: Turbo lives **outside** the form/table wrapper,
not inside it. The Auto components need only two small escape hatches.

#### Need 1 — Frame targeting on forms

`FormComponent` already accepts a `data:` kwarg. `AutoFormComponent` just
forwards it. Host wraps the call in a `<turbo-frame>`:

```erb
<turbo-frame id="contact_form">
  <%= ui_auto_form schema: ContactSchema,
                   record: @contact,
                   action: contact_path(@contact),
                   method: :patch,
                   data: { turbo_frame: "contact_form" } %>
</turbo-frame>
```

No new component code beyond kwarg passthrough.

#### Need 2 — Stable row IDs in tables

For `turbo_stream.replace(dom_id(contact), ...)` to find the row, the table
must emit `<tr id="contact_123">`. Add a `row_id:` lambda to
`DataTableComponent` (and propagate from `AutoTableComponent`):

```erb
<%= ui_auto_table schema: ContactSchema,
                  items:  @contacts,
                  row_id: ->(c) { dom_id(c) } %>
```

Controller stream response is pure Rails, untouched by the gem:

```ruby
respond_to do |format|
  format.turbo_stream do
    render turbo_stream: turbo_stream.replace(
      dom_id(@contact), partial: "contacts/row", locals: { contact: @contact }
    )
  end
end
```

The `contacts/row` partial can still call `ui_auto_show` or `ui_auto_form`
inside `<turbo-frame id="<%= dom_id(@contact) %>">`.

#### What Turbo does NOT need from the gem

- **Stream responses** — Rails feature, no UI concern.
- **Frame URLs on links** — `ui_button href:` and `data:` already forward
  arbitrary attributes.
- **Broadcasts** — `Contact.broadcasts_to :contacts` is model-side.

#### Where it genuinely gets tricky

**Inline-edit-row UIs** (click row → row swaps to a form in place) are a
*different page shape*, not a variant of edit. Don't try to express this via
Auto components. Host writes a custom row partial that calls `ui_auto_form`
inside whatever inline-row layout it needs.

Same for **modal forms that broadcast**: wrap `ui_auto_form` in `ui_modal` +
`<turbo-frame>`, point the controller at a stream response. Auto layer is
unchanged.

#### Additions to the v1 build order

Two small items, appended to the commit list:

- `DataTableComponent` accepts `row_id:` lambda, emits `<tr id="...">`.
- `AutoFormComponent` forwards `data:` to `FormComponent`.
- `AutoTableComponent` forwards `row_id:` to `DataTableComponent`.

### Page archetypes — what to ship vs. skip

Beyond `new/edit/show/index`, only a few page shapes are reusable enough to
earn a place in the gem.

| Page | Ship? | Why | Existing pieces |
|---|---|---|---|
| Dashboard | **Yes** (v2) | Every app has one; composable from existing cards | `ui_stat_card`, `ui_chart_card`, `ui_section`, `ui_grid` |
| Settings / Account | **Yes** (v2) | An edit page with grouped sections | `ui_form_page`, `ui_section`, `ui_form_field` |
| Detail w/ tabs | **Yes** (v2) | Common "show + activity + notes" shape | `ui_show_page`, `ui_tab_switcher` |
| Empty state | **Yes** (v1.x) | Already on roadmap | `ui_empty_state` planned |
| Wizards / multi-step forms | No | Per-app divergence is too high |  |
| Kanban / board | No | Real product decision, not a UI primitive |  |
| Calendar / scheduler | No | Standalone problem domain |  |
| Bulk-select indexes | No | Selection model varies too much |  |

Skipped categories are better as separate small gems if a pattern ever
stabilizes across multiple apps.

### Absorbing dashboards (was: `dash_kit`)

`dash_kit` lives at https://github.com/tylercschneider/dash_kit. Its core
problem is **it ships migrations** to persist user preferences — that couples
it to the host's DB schema and breaks the keystone principle of "UI only, no
persistence."

#### Fix: invert ownership of persistence

Keystone already does this for `ColumnPickerComponent`: the gem renders the
UI, the host owns the storage via a `save_url`. Dashboards must follow the
same pattern. **The gem never ships a migration.**

Two clean options:

**Option A — Persistence-free (recommended default).**
Gem renders + emits change events via Stimulus. Host wires the event to its
own controller and its own DB. Same pattern as the column picker. Zero
migrations, zero coupling.

**Option B — Pluggable store interface (later sugar).**
Define `Keystone::Preferences::Store` interface:

```ruby
module Keystone::Preferences::Store
  def get(user, key); end
  def set(user, key, value); end
end
```

Ship a default `JsonColumnStore` adapter that reads/writes a `preferences`
jsonb column. Host adds *its own* one-line migration if it wants that
adapter — gem still ships none.

Default to A. B is sugar that can come later.

#### Dashboard schema — same shape as resource schema

```ruby
# app/schemas/contacts_dashboard.rb
ContactsDashboard = Keystone::Ui::Dashboard.define do
  stat   :total_contacts,  -> { Contact.count },                       label: "Total"
  stat   :new_this_week,   -> { Contact.where("created_at > ?", 1.week.ago).count }
  chart  :signups_by_day,  -> { Contact.group_by_day(:created_at).count }, type: :line
  table  :recent,          schema: ContactSchema, items: -> { Contact.order(created_at: :desc).limit(5) }
end
```

```erb
<%# app/views/contacts/dashboard.html.erb %>
<%= ui_page do %>
  <%= ui_page_header title: "Contacts overview" %>
  <%= ui_auto_dashboard dashboard: ContactsDashboard %>
<% end %>
```

User preferences (widget order, hidden widgets) flow through the same
event-emitting pattern as `ColumnPickerComponent` — host persists.

#### Status

- v2 work — not part of the v1 schema/auto-component build.
- Migration-free constraint must be preserved so this section doesn't drift
  back toward a `dash_kit`-style coupling.

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
