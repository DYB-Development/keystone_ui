# frozen_string_literal: true

require "ostruct"
require "spec_helper"
require_relative "../../../app/components/keystone/ui/swipe_deck_component"

RSpec.describe Keystone::Ui::SwipeDeckComponent do
  let(:items) do
    [
      OpenStruct.new(id: 1, name: "Meditate"),
      OpenStruct.new(id: 2, name: "Exercise"),
      OpenStruct.new(id: 3, name: "Read")
    ]
  end

  describe "#card_data" do
    it "returns items with z-index and transform for stacked appearance" do
      component = described_class.new(items: items)
      data = component.card_data

      expect(data.length).to eq(3)
      expect(data[0]).to eq({ item: items[0], index: 0, z_index: 3, transform: "scale(1.0) translateY(0px)" })
      expect(data[1]).to eq({ item: items[1], index: 1, z_index: 2, transform: "scale(0.95) translateY(8px)" })
      expect(data[2]).to eq({ item: items[2], index: 2, z_index: 1, transform: "scale(0.9) translateY(16px)" })
    end
  end

  describe "#empty?" do
    it "returns true when items are empty" do
      component = described_class.new(items: [])
      expect(component.empty?).to be true
    end

    it "returns false when items are present" do
      component = described_class.new(items: items)
      expect(component.empty?).to be false
    end
  end

  describe "defaults" do
    it "has default empty_title" do
      component = described_class.new(items: [])
      expect(component.instance_variable_get(:@empty_title)).to eq("All done!")
    end

    it "has nil empty_subtitle by default" do
      component = described_class.new(items: [])
      expect(component.instance_variable_get(:@empty_subtitle)).to be_nil
    end

    it "accepts custom empty_title and empty_subtitle" do
      component = described_class.new(items: [], empty_title: "Finished!", empty_subtitle: "Nothing left.")
      expect(component.instance_variable_get(:@empty_title)).to eq("Finished!")
      expect(component.instance_variable_get(:@empty_subtitle)).to eq("Nothing left.")
    end
  end

  describe "#item_id" do
    it "returns item.id when item responds to id" do
      component = described_class.new(items: items)
      expect(component.item_id(items[0])).to eq(1)
    end

    it "falls back to index when item does not respond to id" do
      hash_item = { name: "Hash item" }
      component = described_class.new(items: [hash_item])
      expect(component.item_id(hash_item, fallback_index: 0)).to eq(0)
    end
  end
end
