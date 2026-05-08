# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::MultiSelectComponent do
  it "returns display text as All label when nothing selected" do
    component = described_class.new(name: "cat[]", label: "Categories", options: [ [ "Shoes", 1 ] ])

    expect(component.display_text).to eq("All Categories")
  end

  it "returns count when items are selected" do
    component = described_class.new(name: "cat[]", label: "Categories", options: [ [ "Shoes", 1 ], [ "Hats", 2 ] ], selected: [ "1", "2" ])

    expect(component.display_text).to eq("2 selected")
  end

  it "reports whether a value is selected" do
    component = described_class.new(name: "cat[]", label: "Categories", options: [ [ "Shoes", 1 ], [ "Hats", 2 ] ], selected: [ 1 ])

    expect(component.selected?(1)).to be true
    expect(component.selected?(2)).to be false
  end
end
