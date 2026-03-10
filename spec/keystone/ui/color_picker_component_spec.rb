# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::ColorPickerComponent do
  it "stores name and default value" do
    component = described_class.new(name: "accent", value: "#3b82f6")

    expect(component.name).to eq("accent")
    expect(component.value).to eq("#3b82f6")
  end
end
