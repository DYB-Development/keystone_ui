# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/components/keystone/ui/column"
require_relative "../../../app/components/keystone/ui/column_picker_component"

RSpec.describe Keystone::Ui::ColumnPickerComponent do
  let(:columns) do
    [
      Keystone::Ui::Column.new(:name, "Name"),
      Keystone::Ui::Column.new(:quantity, "Quantity", hideable: true),
      Keystone::Ui::Column.new(:price, "Price", hideable: true)
    ]
  end

  describe "#hideable_columns" do
    it "returns only columns marked as hideable" do
      component = described_class.new(columns: columns)

      expect(component.hideable_columns.map(&:key)).to eq([ :quantity, :price ])
    end
  end

  describe "#hidden?" do
    it "returns true for columns in hidden_columns list" do
      component = described_class.new(columns: columns, hidden_columns: [ :quantity ])

      expect(component.hidden?(:quantity)).to be true
      expect(component.hidden?(:price)).to be false
    end

    it "handles string keys" do
      component = described_class.new(columns: columns, hidden_columns: [ "quantity" ])

      expect(component.hidden?(:quantity)).to be true
    end
  end

  describe "initialization" do
    it "defaults hidden_columns to empty" do
      component = described_class.new(columns: columns)

      expect(component.hidden?(:quantity)).to be false
    end

    it "accepts save_url" do
      component = described_class.new(columns: columns, save_url: "/prefs")

      expect(component.save_url).to eq("/prefs")
    end
  end
end
