# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::OptionCardComponent do
  it "exposes base classes with border" do
    component = described_class.new(name: "theme", value: "forest")

    expect(component.classes).to include("border-2")
    expect(component.classes).to include("rounded-lg")
    expect(component.classes).to include("cursor-pointer")
  end

  it "uses transparent border when not selected" do
    component = described_class.new(name: "theme", value: "forest", selected: false)

    expect(component.classes).to include("border-transparent")
    expect(component.classes).not_to include("border-accent-500")
  end

  it "uses accent border when selected" do
    component = described_class.new(name: "theme", value: "forest", selected: true)

    expect(component.classes).to include("border-accent-500")
    expect(component.classes).not_to include("border-transparent")
  end

  it "exposes name, value, and selected" do
    component = described_class.new(name: "color", value: "blue", selected: true)

    expect(component.name).to eq("color")
    expect(component.value).to eq("blue")
    expect(component.selected?).to be true
  end

  it "defaults selected to false" do
    component = described_class.new(name: "color", value: "blue")

    expect(component.selected?).to be false
  end
end
