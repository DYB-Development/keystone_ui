# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/components/keystone/ui/column"
require_relative "../../../app/components/keystone/ui/data_table_component"

RSpec.describe Keystone::Ui::DataTableComponent do
  let(:columns) { [{ name: "Name" }, { quantity: "Quantity" }, { price: "Price" }] }
  let(:hash_items) do
    [
      { name: "Apples", quantity: 10, price: "$1.50" },
      { name: "Bananas", quantity: 5, price: "$0.75" }
    ]
  end

  describe "#header_cells" do
    it "generates header cells from column labels with position-based classes" do
      component = described_class.new(items: hash_items, columns: columns)

      expect(component.header_cells).to eq([
        { label: "Name", classes: described_class::HEADER_CLASSES_FIRST, scope: "col" },
        { label: "Quantity", classes: described_class::HEADER_CLASSES_MIDDLE, scope: "col" },
        { label: "Price", classes: described_class::HEADER_CLASSES_LAST, scope: "col" }
      ])
    end

    it "assigns FIRST and LAST correctly for a 2-column layout" do
      two_columns = [{ name: "Name" }, { price: "Price" }]
      component = described_class.new(items: hash_items, columns: two_columns)

      expect(component.header_cells).to eq([
        { label: "Name", classes: described_class::HEADER_CLASSES_FIRST, scope: "col" },
        { label: "Price", classes: described_class::HEADER_CLASSES_LAST, scope: "col" }
      ])
    end
  end

  describe "#row_cells" do
    it "resolves values from hash items" do
      component = described_class.new(items: hash_items, columns: columns)

      expect(component.row_cells).to eq([
        [
          { value: "Apples", classes: described_class::ROW_CLASSES_FIRST },
          { value: 10, classes: described_class::ROW_CLASSES_MIDDLE },
          { value: "$1.50", classes: described_class::ROW_CLASSES_LAST }
        ],
        [
          { value: "Bananas", classes: described_class::ROW_CLASSES_FIRST },
          { value: 5, classes: described_class::ROW_CLASSES_MIDDLE },
          { value: "$0.75", classes: described_class::ROW_CLASSES_LAST }
        ]
      ])
    end

    it "resolves values from objects that respond to methods" do
      Product = Struct.new(:name, :quantity, :price, keyword_init: true)
      struct_items = [
        Product.new(name: "Widget", quantity: 20, price: "$9.99")
      ]

      component = described_class.new(items: struct_items, columns: columns)

      expect(component.row_cells).to eq([
        [
          { value: "Widget", classes: described_class::ROW_CLASSES_FIRST },
          { value: 20, classes: described_class::ROW_CLASSES_MIDDLE },
          { value: "$9.99", classes: described_class::ROW_CLASSES_LAST }
        ]
      ])
    end

    it "assigns position-based row classes correctly" do
      component = described_class.new(items: [hash_items.first], columns: columns)
      row = component.row_cells.first

      expect(row[0][:classes]).to eq(described_class::ROW_CLASSES_FIRST)
      expect(row[1][:classes]).to eq(described_class::ROW_CLASSES_MIDDLE)
      expect(row[2][:classes]).to eq(described_class::ROW_CLASSES_LAST)
    end
  end

  describe "#empty?" do
    it "returns true when items are empty" do
      component = described_class.new(items: [], columns: columns)
      expect(component.empty?).to be true
    end

    it "returns false when items are present" do
      component = described_class.new(items: hash_items, columns: columns)
      expect(component.empty?).to be false
    end
  end

  describe "#column_count" do
    it "returns the number of columns" do
      component = described_class.new(items: hash_items, columns: columns)
      expect(component.column_count).to eq(3)
    end
  end

  describe "empty_message" do
    it "stores the empty message" do
      component = described_class.new(items: [], columns: columns, empty_message: "No products found.")
      expect(component.instance_variable_get(:@empty_message)).to eq("No products found.")
    end
  end

  describe "actions" do
    it "returns false for actions? when no block is set" do
      component = described_class.new(items: hash_items, columns: columns)
      expect(component.actions?).to be false
    end

    it "returns true for actions? after calling actions with a block" do
      component = described_class.new(items: hash_items, columns: columns)
      component.actions { |item| "Edit #{item[:name]}" }
      expect(component.actions?).to be true
    end

    it "before_render evaluates the content block so actions are registered" do
      component = described_class.new(items: hash_items, columns: columns)
      component.set_content_block do |table|
        table.actions { |item| "Edit #{item[:name]}" }
      end

      expect(component.actions?).to be false
      component.before_render
      expect(component.actions?).to be true
    end

    it "appends an Actions header with LAST classes" do
      component = described_class.new(items: hash_items, columns: columns)
      component.actions { |item| "Edit" }

      headers = component.header_cells
      expect(headers.last).to eq({
        label: "Actions",
        classes: described_class::HEADER_CLASSES_LAST,
        scope: "col"
      })
    end

    it "shifts the last data column from LAST to MIDDLE when actions are present" do
      component = described_class.new(items: hash_items, columns: columns)
      component.actions { |item| "Edit" }

      headers = component.header_cells
      # "Price" was the last data column — should now be MIDDLE
      price_header = headers.find { |h| h[:label] == "Price" }
      expect(price_header[:classes]).to eq(described_class::HEADER_CLASSES_MIDDLE)
    end

    it "shifts row classes so last data column becomes MIDDLE" do
      component = described_class.new(items: [hash_items.first], columns: columns)
      component.actions { |item| "Edit" }

      row = component.row_cells.first
      expect(row[0][:classes]).to eq(described_class::ROW_CLASSES_FIRST)
      expect(row[1][:classes]).to eq(described_class::ROW_CLASSES_MIDDLE)
      expect(row[2][:classes]).to eq(described_class::ROW_CLASSES_MIDDLE)
    end

    it "includes the actions column in column_count" do
      component = described_class.new(items: hash_items, columns: columns)
      component.actions { |item| "Edit" }
      expect(component.column_count).to eq(4)
    end
  end

  describe "linkable cells" do
    it "includes :href in cell hash when link is registered for a column" do
      component = described_class.new(items: hash_items, columns: columns)
      component.link(:name) { |item| "/projects/#{item[:name].downcase}" }
      row = component.row_cells.first

      expect(row[0][:href]).to eq("/projects/apples")
    end

    it "omits :href when no link is registered for the column" do
      component = described_class.new(items: hash_items, columns: columns)
      component.link(:name) { |item| "/projects/#{item[:name].downcase}" }
      row = component.row_cells.first

      expect(row[1]).not_to have_key(:href)
      expect(row[2]).not_to have_key(:href)
    end

    it "resolves link per item" do
      component = described_class.new(items: hash_items, columns: columns)
      component.link(:name) { |item| "/projects/#{item[:name].downcase}" }

      expect(component.row_cells[0][0][:href]).to eq("/projects/apples")
      expect(component.row_cells[1][0][:href]).to eq("/projects/bananas")
    end

    it "before_render evaluates the content block so links are registered" do
      component = described_class.new(items: hash_items, columns: columns)
      component.set_content_block do |table|
        table.link(:name) { |item| "/projects/#{item[:name].downcase}" }
      end

      expect(component.instance_variable_get(:@link_blocks)).to be_empty
      component.before_render
      expect(component.instance_variable_get(:@link_blocks)).to have_key(:name)
    end
  end

  describe "combined actions and linkable cells" do
    it "applies correct position classes with both features" do
      component = described_class.new(items: [hash_items.first], columns: columns)
      component.link(:name) { |item| "/projects/#{item[:name].downcase}" }
      component.actions { |item| "Edit" }

      headers = component.header_cells
      expect(headers[0][:classes]).to eq(described_class::HEADER_CLASSES_FIRST)
      expect(headers[1][:classes]).to eq(described_class::HEADER_CLASSES_MIDDLE)
      expect(headers[2][:classes]).to eq(described_class::HEADER_CLASSES_MIDDLE)
      expect(headers[3][:classes]).to eq(described_class::HEADER_CLASSES_LAST)
      expect(headers[3][:label]).to eq("Actions")

      row = component.row_cells.first
      expect(row[0][:href]).to eq("/projects/apples")
      expect(row[0][:classes]).to eq(described_class::ROW_CLASSES_FIRST)
      expect(row[1][:classes]).to eq(described_class::ROW_CLASSES_MIDDLE)
      expect(row[2][:classes]).to eq(described_class::ROW_CLASSES_MIDDLE)
    end

    it "includes actions in column_count with linkable columns" do
      component = described_class.new(items: hash_items, columns: columns)
      component.link(:name) { |item| "/projects/#{item[:name].downcase}" }
      component.actions { |item| "Edit" }
      expect(component.column_count).to eq(4)
    end
  end

  describe "Column object input" do
    let(:column_objects) do
      [
        Keystone::Ui::Column.new(:name, "Name"),
        Keystone::Ui::Column.new(:quantity, "Quantity"),
        Keystone::Ui::Column.new(:price, "Price")
      ]
    end

    it "accepts Column objects for columns" do
      component = described_class.new(items: hash_items, columns: column_objects)

      expect(component.column_keys).to eq([:name, :quantity, :price])
      expect(component.column_labels).to eq(["Name", "Quantity", "Price"])
    end

    it "generates correct header and row cells from Column objects" do
      component = described_class.new(items: [hash_items.first], columns: column_objects)

      expect(component.header_cells).to eq([
        { label: "Name", classes: described_class::HEADER_CLASSES_FIRST, scope: "col" },
        { label: "Quantity", classes: described_class::HEADER_CLASSES_MIDDLE, scope: "col" },
        { label: "Price", classes: described_class::HEADER_CLASSES_LAST, scope: "col" }
      ])

      expect(component.row_cells).to eq([
        [
          { value: "Apples", classes: described_class::ROW_CLASSES_FIRST },
          { value: 10, classes: described_class::ROW_CLASSES_MIDDLE },
          { value: "$1.50", classes: described_class::ROW_CLASSES_LAST }
        ]
      ])
    end

    it "appends mobile-hidden classes to header and row cells" do
      cols = [
        Keystone::Ui::Column.new(:name, "Name"),
        Keystone::Ui::Column.new(:quantity, "Quantity", mobile_hidden: true),
        Keystone::Ui::Column.new(:price, "Price")
      ]
      component = described_class.new(items: [hash_items.first], columns: cols)

      headers = component.header_cells
      expect(headers[0][:classes]).to eq(described_class::HEADER_CLASSES_FIRST)
      expect(headers[1][:classes]).to eq("#{described_class::HEADER_CLASSES_MIDDLE} #{described_class::MOBILE_HIDDEN_CLASSES}")
      expect(headers[2][:classes]).to eq(described_class::HEADER_CLASSES_LAST)

      row = component.row_cells.first
      expect(row[0][:classes]).to eq(described_class::ROW_CLASSES_FIRST)
      expect(row[1][:classes]).to eq("#{described_class::ROW_CLASSES_MIDDLE} #{described_class::MOBILE_HIDDEN_CLASSES}")
      expect(row[2][:classes]).to eq(described_class::ROW_CLASSES_LAST)
    end

    it "does not append mobile-hidden classes when mobile_hidden is false" do
      cols = [
        Keystone::Ui::Column.new(:name, "Name"),
        Keystone::Ui::Column.new(:price, "Price")
      ]
      component = described_class.new(items: [hash_items.first], columns: cols)

      headers = component.header_cells
      expect(headers[0][:classes]).not_to include(described_class::MOBILE_HIDDEN_CLASSES)
      expect(headers[1][:classes]).not_to include(described_class::MOBILE_HIDDEN_CLASSES)
    end

    it "hash-based columns default to mobile-visible" do
      component = described_class.new(items: [hash_items.first], columns: columns)

      component.header_cells.each do |cell|
        expect(cell[:classes]).not_to include(described_class::MOBILE_HIDDEN_CLASSES)
      end
    end

    it "supports mixed Column objects and hashes" do
      mixed = [
        Keystone::Ui::Column.new(:name, "Name"),
        { quantity: "Quantity" },
        Keystone::Ui::Column.new(:price, "Price")
      ]
      component = described_class.new(items: [hash_items.first], columns: mixed)

      expect(component.column_keys).to eq([:name, :quantity, :price])
      expect(component.column_labels).to eq(["Name", "Quantity", "Price"])
    end
  end

  describe "Column sortable option" do
    it "defaults to not sortable" do
      col = Keystone::Ui::Column.new(:name, "Name")
      expect(col.sortable?).to be false
    end

    it "can be marked as sortable" do
      col = Keystone::Ui::Column.new(:name, "Name", sortable: true)
      expect(col.sortable?).to be true
    end
  end

  describe "sortable headers" do
    let(:sortable_columns) do
      [
        Keystone::Ui::Column.new(:name, "Name", sortable: true),
        Keystone::Ui::Column.new(:quantity, "Quantity"),
        Keystone::Ui::Column.new(:price, "Price", sortable: true)
      ]
    end
    let(:sort_url) { ->(col, dir) { "/products?sort=#{col}&direction=#{dir}" } }

    it "adds sort metadata to sortable header cells" do
      component = described_class.new(
        items: hash_items,
        columns: sortable_columns,
        sort_url: sort_url
      )

      headers = component.header_cells
      expect(headers[0][:sortable]).to be true
      expect(headers[0][:sort_href]).to eq("/products?sort=name&direction=asc")
      expect(headers[0][:sort_active]).to be false

      expect(headers[1][:sortable]).to be false
      expect(headers[1]).not_to have_key(:sort_href)
    end

    it "toggles direction when column is actively sorted asc" do
      component = described_class.new(
        items: hash_items,
        columns: sortable_columns,
        sort: :name,
        sort_direction: :asc,
        sort_url: sort_url
      )

      headers = component.header_cells
      expect(headers[0][:sort_active]).to be true
      expect(headers[0][:sort_direction]).to eq(:asc)
      expect(headers[0][:sort_href]).to eq("/products?sort=name&direction=desc")
    end

    it "toggles direction when column is actively sorted desc" do
      component = described_class.new(
        items: hash_items,
        columns: sortable_columns,
        sort: :name,
        sort_direction: :desc,
        sort_url: sort_url
      )

      headers = component.header_cells
      expect(headers[0][:sort_active]).to be true
      expect(headers[0][:sort_direction]).to eq(:desc)
      expect(headers[0][:sort_href]).to eq("/products?sort=name&direction=asc")
    end

    it "defaults inactive sortable columns to asc" do
      component = described_class.new(
        items: hash_items,
        columns: sortable_columns,
        sort: :name,
        sort_direction: :asc,
        sort_url: sort_url
      )

      headers = component.header_cells
      # price is sortable but not active — defaults to asc
      expect(headers[2][:sort_active]).to be false
      expect(headers[2][:sort_href]).to eq("/products?sort=price&direction=asc")
    end

    it "works without sort params (backward compatible)" do
      component = described_class.new(items: hash_items, columns: sortable_columns)

      headers = component.header_cells
      expect(headers[0]).not_to have_key(:sortable)
      expect(headers[0]).not_to have_key(:sort_href)
    end
  end

  describe "Column hideable option" do
    it "defaults to not hideable" do
      col = Keystone::Ui::Column.new(:name, "Name")
      expect(col.hideable?).to be false
    end

    it "can be marked as hideable" do
      col = Keystone::Ui::Column.new(:name, "Name", hideable: true)
      expect(col.hideable?).to be true
    end
  end

  describe "hidden_columns filtering" do
    let(:hideable_columns) do
      [
        Keystone::Ui::Column.new(:name, "Name"),
        Keystone::Ui::Column.new(:quantity, "Quantity", hideable: true),
        Keystone::Ui::Column.new(:price, "Price", hideable: true)
      ]
    end

    it "filters out hidden columns from header_cells" do
      component = described_class.new(
        items: hash_items,
        columns: hideable_columns,
        hidden_columns: [:quantity]
      )

      labels = component.header_cells.map { |c| c[:label] }
      expect(labels).to eq(["Name", "Price"])
    end

    it "filters out hidden columns from row_cells" do
      component = described_class.new(
        items: hash_items,
        columns: hideable_columns,
        hidden_columns: [:quantity]
      )

      row = component.row_cells.first
      expect(row.length).to eq(2)
      expect(row[0][:value]).to eq("Apples")
      expect(row[1][:value]).to eq("$1.50")
    end

    it "ignores hidden_columns for non-hideable columns" do
      component = described_class.new(
        items: hash_items,
        columns: hideable_columns,
        hidden_columns: [:name]
      )

      labels = component.header_cells.map { |c| c[:label] }
      expect(labels).to eq(["Name", "Quantity", "Price"])
    end

    it "works with no hidden_columns (backward compatible)" do
      component = described_class.new(items: hash_items, columns: hideable_columns)

      labels = component.header_cells.map { |c| c[:label] }
      expect(labels).to eq(["Name", "Quantity", "Price"])
    end
  end
end
