# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::MultiSelectComponent do
  it "returns display text as All label when nothing selected" do
    component = described_class.new(name: "cat[]", label: "Categories", options: [["Shoes", 1]])

    expect(component.display_text).to eq("All Categories")
  end
end
