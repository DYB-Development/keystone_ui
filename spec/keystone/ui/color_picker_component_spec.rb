# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::ColorPickerComponent do
  it "stores name and default value" do
    component = described_class.new(name: "accent", value: "#3b82f6")

    expect(component.name).to eq("accent")
    expect(component.value).to eq("#3b82f6")
  end

  it "defaults value to #000000" do
    component = described_class.new(name: "accent")

    expect(component.value).to eq("#000000")
  end

  it "uses the color-picker Stimulus controller" do
    component = described_class.new(name: "accent")

    expect(component.controller_name).to eq("color-picker")
  end

  it "provides swatch classes for the trigger" do
    component = described_class.new(name: "accent")

    expect(component.swatch_classes).to include("rounded-lg")
    expect(component.swatch_classes).to include("cursor-pointer")
    expect(component.swatch_classes).to include("border")
  end

  it "provides panel classes for the dropdown" do
    component = described_class.new(name: "accent")

    expect(component.panel_classes).to include("absolute")
    expect(component.panel_classes).to include("rounded-lg")
    expect(component.panel_classes).to include("shadow-lg")
    expect(component.panel_classes).to include("hidden")
  end

  it "accepts an optional label" do
    component = described_class.new(name: "accent", label: "Accent Color")

    expect(component.label).to eq("Accent Color")
  end
end
