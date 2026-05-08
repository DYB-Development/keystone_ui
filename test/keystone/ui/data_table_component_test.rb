# frozen_string_literal: true

require "test_helper"
require_relative "../../../app/components/keystone/ui/column"
require_relative "../../../app/components/keystone/ui/data_table_component"

class Keystone::Ui::DataTableComponentTest < Minitest::Test
  PRODUCT_STRUCT = Struct.new(:name, :quantity, :price, keyword_init: true)

  def columns
    @columns ||= [ { name: "Name" }, { quantity: "Quantity" }, { price: "Price" } ]
  end

  def hash_items
    @hash_items ||= [
      { name: "Apples", quantity: 10, price: "$1.50" },
      { name: "Bananas", quantity: 5, price: "$0.75" }
    ]
  end

  def column_objects
    @column_objects ||= [
      Keystone::Ui::Column.new(:name, "Name"),
      Keystone::Ui::Column.new(:quantity, "Quantity"),
      Keystone::Ui::Column.new(:price, "Price")
    ]
  end

  def sortable_columns
    @sortable_columns ||= [
      Keystone::Ui::Column.new(:name, "Name", sortable: true),
      Keystone::Ui::Column.new(:quantity, "Quantity"),
      Keystone::Ui::Column.new(:price, "Price", sortable: true)
    ]
  end

  def sort_url
    @sort_url ||= ->(col, dir) { "/products?sort=#{col}&direction=#{dir}" }
  end

  def hideable_columns
    @hideable_columns ||= [
      Keystone::Ui::Column.new(:name, "Name"),
      Keystone::Ui::Column.new(:quantity, "Quantity", hideable: true),
      Keystone::Ui::Column.new(:price, "Price", hideable: true)
    ]
  end

  def klass
    Keystone::Ui::DataTableComponent
  end

  # ---- header_cells

  def test_header_cells_generates_header_cells_from_column_labels_with_position_based_classes
    component = klass.new(items: hash_items, columns: columns)

    assert_equal [
      { label: "Name", classes: klass::HEADER_CLASSES_FIRST, scope: "col" },
      { label: "Quantity", classes: klass::HEADER_CLASSES_MIDDLE, scope: "col" },
      { label: "Price", classes: klass::HEADER_CLASSES_LAST, scope: "col" }
    ], component.header_cells
  end

  def test_header_cells_assigns_first_and_last_correctly_for_a_2_column_layout
    two_columns = [ { name: "Name" }, { price: "Price" } ]
    component = klass.new(items: hash_items, columns: two_columns)

    assert_equal [
      { label: "Name", classes: klass::HEADER_CLASSES_FIRST, scope: "col" },
      { label: "Price", classes: klass::HEADER_CLASSES_LAST, scope: "col" }
    ], component.header_cells
  end

  # ---- row_cells

  def test_row_cells_resolves_values_from_hash_items
    component = klass.new(items: hash_items, columns: columns)

    assert_equal [
      [
        { value: "Apples", classes: klass::ROW_CLASSES_FIRST },
        { value: 10, classes: klass::ROW_CLASSES_MIDDLE },
        { value: "$1.50", classes: klass::ROW_CLASSES_LAST }
      ],
      [
        { value: "Bananas", classes: klass::ROW_CLASSES_FIRST },
        { value: 5, classes: klass::ROW_CLASSES_MIDDLE },
        { value: "$0.75", classes: klass::ROW_CLASSES_LAST }
      ]
    ], component.row_cells
  end

  def test_row_cells_resolves_values_from_objects_that_respond_to_methods
    struct_items = [ PRODUCT_STRUCT.new(name: "Widget", quantity: 20, price: "$9.99") ]

    component = klass.new(items: struct_items, columns: columns)

    assert_equal [
      [
        { value: "Widget", classes: klass::ROW_CLASSES_FIRST },
        { value: 20, classes: klass::ROW_CLASSES_MIDDLE },
        { value: "$9.99", classes: klass::ROW_CLASSES_LAST }
      ]
    ], component.row_cells
  end

  def test_row_cells_assigns_position_based_row_classes_correctly
    component = klass.new(items: [ hash_items.first ], columns: columns)
    row = component.row_cells.first

    assert_equal klass::ROW_CLASSES_FIRST, row[0][:classes]
    assert_equal klass::ROW_CLASSES_MIDDLE, row[1][:classes]
    assert_equal klass::ROW_CLASSES_LAST, row[2][:classes]
  end

  # ---- empty?

  def test_empty_returns_true_when_items_are_empty
    component = klass.new(items: [], columns: columns)
    assert_equal true, component.empty?
  end

  def test_empty_returns_false_when_items_are_present
    component = klass.new(items: hash_items, columns: columns)
    assert_equal false, component.empty?
  end

  # ---- column_count

  def test_column_count_returns_the_number_of_columns
    component = klass.new(items: hash_items, columns: columns)
    assert_equal 3, component.column_count
  end

  # ---- empty_message

  def test_empty_message_stores_the_empty_message
    component = klass.new(items: [], columns: columns, empty_message: "No products found.")
    assert_equal "No products found.", component.instance_variable_get(:@empty_message)
  end

  # ---- actions

  def test_actions_returns_false_for_actions_when_no_block_is_set
    component = klass.new(items: hash_items, columns: columns)
    assert_equal false, component.actions?
  end

  def test_actions_returns_true_for_actions_after_calling_actions_with_a_block
    component = klass.new(items: hash_items, columns: columns)
    component.actions { |item| "Edit #{item[:name]}" }
    assert_equal true, component.actions?
  end

  def test_actions_before_render_evaluates_the_content_block_so_actions_are_registered
    component = klass.new(items: hash_items, columns: columns)
    component.set_content_block do |table|
      table.actions { |item| "Edit #{item[:name]}" }
    end

    assert_equal false, component.actions?
    component.before_render
    assert_equal true, component.actions?
  end

  def test_actions_appends_an_actions_header_with_last_classes
    component = klass.new(items: hash_items, columns: columns)
    component.actions { |item| "Edit" }

    headers = component.header_cells
    assert_equal({ label: "Actions", classes: klass::HEADER_CLASSES_LAST, scope: "col" }, headers.last)
  end

  def test_actions_shifts_the_last_data_column_from_last_to_middle_when_actions_are_present
    component = klass.new(items: hash_items, columns: columns)
    component.actions { |item| "Edit" }

    headers = component.header_cells
    price_header = headers.find { |h| h[:label] == "Price" }
    assert_equal klass::HEADER_CLASSES_MIDDLE, price_header[:classes]
  end

  def test_actions_shifts_row_classes_so_last_data_column_becomes_middle
    component = klass.new(items: [ hash_items.first ], columns: columns)
    component.actions { |item| "Edit" }

    row = component.row_cells.first
    assert_equal klass::ROW_CLASSES_FIRST, row[0][:classes]
    assert_equal klass::ROW_CLASSES_MIDDLE, row[1][:classes]
    assert_equal klass::ROW_CLASSES_MIDDLE, row[2][:classes]
  end

  def test_actions_includes_the_actions_column_in_column_count
    component = klass.new(items: hash_items, columns: columns)
    component.actions { |item| "Edit" }
    assert_equal 4, component.column_count
  end

  # ---- linkable cells

  def test_linkable_includes_href_in_cell_hash_when_link_is_registered_for_a_column
    component = klass.new(items: hash_items, columns: columns)
    component.link(:name) { |item| "/projects/#{item[:name].downcase}" }
    row = component.row_cells.first

    assert_equal "/projects/apples", row[0][:href]
  end

  def test_linkable_omits_href_when_no_link_is_registered_for_the_column
    component = klass.new(items: hash_items, columns: columns)
    component.link(:name) { |item| "/projects/#{item[:name].downcase}" }
    row = component.row_cells.first

    refute row[1].key?(:href)
    refute row[2].key?(:href)
  end

  def test_linkable_resolves_link_per_item
    component = klass.new(items: hash_items, columns: columns)
    component.link(:name) { |item| "/projects/#{item[:name].downcase}" }

    assert_equal "/projects/apples", component.row_cells[0][0][:href]
    assert_equal "/projects/bananas", component.row_cells[1][0][:href]
  end

  def test_linkable_before_render_evaluates_the_content_block_so_links_are_registered
    component = klass.new(items: hash_items, columns: columns)
    component.set_content_block do |table|
      table.link(:name) { |item| "/projects/#{item[:name].downcase}" }
    end

    assert_empty component.instance_variable_get(:@link_blocks)
    component.before_render
    assert component.instance_variable_get(:@link_blocks).key?(:name)
  end

  # ---- combined actions and linkable

  def test_combined_applies_correct_position_classes_with_both_features
    component = klass.new(items: [ hash_items.first ], columns: columns)
    component.link(:name) { |item| "/projects/#{item[:name].downcase}" }
    component.actions { |item| "Edit" }

    headers = component.header_cells
    assert_equal klass::HEADER_CLASSES_FIRST, headers[0][:classes]
    assert_equal klass::HEADER_CLASSES_MIDDLE, headers[1][:classes]
    assert_equal klass::HEADER_CLASSES_MIDDLE, headers[2][:classes]
    assert_equal klass::HEADER_CLASSES_LAST, headers[3][:classes]
    assert_equal "Actions", headers[3][:label]

    row = component.row_cells.first
    assert_equal "/projects/apples", row[0][:href]
    assert_equal klass::ROW_CLASSES_FIRST, row[0][:classes]
    assert_equal klass::ROW_CLASSES_MIDDLE, row[1][:classes]
    assert_equal klass::ROW_CLASSES_MIDDLE, row[2][:classes]
  end

  def test_combined_includes_actions_in_column_count_with_linkable_columns
    component = klass.new(items: hash_items, columns: columns)
    component.link(:name) { |item| "/projects/#{item[:name].downcase}" }
    component.actions { |item| "Edit" }
    assert_equal 4, component.column_count
  end

  # ---- Column object input

  def test_column_objects_accepts_column_objects_for_columns
    component = klass.new(items: hash_items, columns: column_objects)

    assert_equal [ :name, :quantity, :price ], component.column_keys
    assert_equal [ "Name", "Quantity", "Price" ], component.column_labels
  end

  def test_column_objects_generates_correct_header_and_row_cells
    component = klass.new(items: [ hash_items.first ], columns: column_objects)

    assert_equal [
      { label: "Name", classes: klass::HEADER_CLASSES_FIRST, scope: "col" },
      { label: "Quantity", classes: klass::HEADER_CLASSES_MIDDLE, scope: "col" },
      { label: "Price", classes: klass::HEADER_CLASSES_LAST, scope: "col" }
    ], component.header_cells

    assert_equal [
      [
        { value: "Apples", classes: klass::ROW_CLASSES_FIRST },
        { value: 10, classes: klass::ROW_CLASSES_MIDDLE },
        { value: "$1.50", classes: klass::ROW_CLASSES_LAST }
      ]
    ], component.row_cells
  end

  def test_column_objects_appends_mobile_hidden_classes
    cols = [
      Keystone::Ui::Column.new(:name, "Name"),
      Keystone::Ui::Column.new(:quantity, "Quantity", mobile_hidden: true),
      Keystone::Ui::Column.new(:price, "Price")
    ]
    component = klass.new(items: [ hash_items.first ], columns: cols)

    headers = component.header_cells
    assert_equal klass::HEADER_CLASSES_FIRST, headers[0][:classes]
    assert_equal "#{klass::HEADER_CLASSES_MIDDLE} #{klass::MOBILE_HIDDEN_CLASSES}", headers[1][:classes]
    assert_equal klass::HEADER_CLASSES_LAST, headers[2][:classes]

    row = component.row_cells.first
    assert_equal klass::ROW_CLASSES_FIRST, row[0][:classes]
    assert_equal "#{klass::ROW_CLASSES_MIDDLE} #{klass::MOBILE_HIDDEN_CLASSES}", row[1][:classes]
    assert_equal klass::ROW_CLASSES_LAST, row[2][:classes]
  end

  def test_column_objects_does_not_append_mobile_hidden_when_false
    cols = [
      Keystone::Ui::Column.new(:name, "Name"),
      Keystone::Ui::Column.new(:price, "Price")
    ]
    component = klass.new(items: [ hash_items.first ], columns: cols)

    headers = component.header_cells
    refute_includes headers[0][:classes], klass::MOBILE_HIDDEN_CLASSES
    refute_includes headers[1][:classes], klass::MOBILE_HIDDEN_CLASSES
  end

  def test_column_objects_hash_columns_default_to_mobile_visible
    component = klass.new(items: [ hash_items.first ], columns: columns)

    component.header_cells.each do |cell|
      refute_includes cell[:classes], klass::MOBILE_HIDDEN_CLASSES
    end
  end

  def test_column_objects_supports_mixed_column_objects_and_hashes
    mixed = [
      Keystone::Ui::Column.new(:name, "Name"),
      { quantity: "Quantity" },
      Keystone::Ui::Column.new(:price, "Price")
    ]
    component = klass.new(items: [ hash_items.first ], columns: mixed)

    assert_equal [ :name, :quantity, :price ], component.column_keys
    assert_equal [ "Name", "Quantity", "Price" ], component.column_labels
  end

  # ---- Column sortable option

  def test_column_sortable_defaults_to_not_sortable
    col = Keystone::Ui::Column.new(:name, "Name")
    assert_equal false, col.sortable?
  end

  def test_column_sortable_can_be_marked_as_sortable
    col = Keystone::Ui::Column.new(:name, "Name", sortable: true)
    assert_equal true, col.sortable?
  end

  # ---- sortable headers

  def test_sortable_headers_adds_sort_metadata_to_sortable_header_cells
    component = klass.new(items: hash_items, columns: sortable_columns, sort_url: sort_url)

    headers = component.header_cells
    assert_equal true, headers[0][:sortable]
    assert_equal "/products?sort=name&direction=asc", headers[0][:sort_href]
    assert_equal false, headers[0][:sort_active]

    assert_equal false, headers[1][:sortable]
    refute headers[1].key?(:sort_href)
  end

  def test_sortable_headers_toggles_direction_when_active_asc
    component = klass.new(items: hash_items, columns: sortable_columns, sort: :name, sort_direction: :asc, sort_url: sort_url)

    headers = component.header_cells
    assert_equal true, headers[0][:sort_active]
    assert_equal :asc, headers[0][:sort_direction]
    assert_equal "/products?sort=name&direction=desc", headers[0][:sort_href]
  end

  def test_sortable_headers_toggles_direction_when_active_desc
    component = klass.new(items: hash_items, columns: sortable_columns, sort: :name, sort_direction: :desc, sort_url: sort_url)

    headers = component.header_cells
    assert_equal true, headers[0][:sort_active]
    assert_equal :desc, headers[0][:sort_direction]
    assert_equal "/products?sort=name&direction=asc", headers[0][:sort_href]
  end

  def test_sortable_headers_defaults_inactive_sortable_columns_to_asc
    component = klass.new(items: hash_items, columns: sortable_columns, sort: :name, sort_direction: :asc, sort_url: sort_url)

    headers = component.header_cells
    assert_equal false, headers[2][:sort_active]
    assert_equal "/products?sort=price&direction=asc", headers[2][:sort_href]
  end

  def test_sortable_headers_works_without_sort_params
    component = klass.new(items: hash_items, columns: sortable_columns)

    headers = component.header_cells
    refute headers[0].key?(:sortable)
    refute headers[0].key?(:sort_href)
  end

  # ---- Column hideable option

  def test_column_hideable_defaults_to_not_hideable
    col = Keystone::Ui::Column.new(:name, "Name")
    assert_equal false, col.hideable?
  end

  def test_column_hideable_can_be_marked_as_hideable
    col = Keystone::Ui::Column.new(:name, "Name", hideable: true)
    assert_equal true, col.hideable?
  end

  # ---- hidden_columns filtering

  def test_hidden_columns_filters_from_header_cells
    component = klass.new(items: hash_items, columns: hideable_columns, hidden_columns: [ :quantity ])

    labels = component.header_cells.map { |c| c[:label] }
    assert_equal [ "Name", "Price" ], labels
  end

  def test_hidden_columns_filters_from_row_cells
    component = klass.new(items: hash_items, columns: hideable_columns, hidden_columns: [ :quantity ])

    row = component.row_cells.first
    assert_equal 2, row.length
    assert_equal "Apples", row[0][:value]
    assert_equal "$1.50", row[1][:value]
  end

  def test_hidden_columns_ignores_for_non_hideable
    component = klass.new(items: hash_items, columns: hideable_columns, hidden_columns: [ :name ])

    labels = component.header_cells.map { |c| c[:label] }
    assert_equal [ "Name", "Quantity", "Price" ], labels
  end

  def test_hidden_columns_works_with_no_hidden_columns
    component = klass.new(items: hash_items, columns: hideable_columns)

    labels = component.header_cells.map { |c| c[:label] }
    assert_equal [ "Name", "Quantity", "Price" ], labels
  end
end
