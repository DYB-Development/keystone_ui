# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::AlertComponent do
  it "returns info classes by default" do
    component = described_class.new(message: "FYI")

    expect(component.classes).to include("bg-accent-50")
    expect(component.classes).to include("text-accent-800")
  end

  it "maps each type to its variant classes" do
    %i[success warning error].each do |type|
      component = described_class.new(message: "msg", type: type)
      expect(component.classes).to include(described_class::TYPE_CLASSES[type])
    end
  end

  it "exposes message_text" do
    component = described_class.new(message: "Item saved!")

    expect(component.message_text).to eq("Item saved!")
  end

  it "exposes title when provided" do
    component = described_class.new(message: "Could not save", title: "Error")

    expect(component.title?).to be true
    expect(component.title_text).to eq("Error")
  end

  it "returns false for title? when not provided" do
    component = described_class.new(message: "FYI")

    expect(component.title?).to be false
  end

  it "exposes dismissible? flag" do
    expect(described_class.new(message: "x", dismissible: true).dismissible?).to be true
    expect(described_class.new(message: "x").dismissible?).to be false
  end

  it "uses semantic accent classes for info type" do
    component = described_class.new(message: "FYI", type: :info)

    expect(component.classes).to include("bg-accent-50")
    expect(component.classes).to include("text-accent-800")
    expect(component.classes).to include("dark:bg-accent-900/30")
    expect(component.classes).to include("dark:text-accent-300")
  end

  it "provides Stimulus controller data for dismissible alerts" do
    component = described_class.new(message: "x", dismissible: true)

    expect(component.wrapper_data[:controller]).to eq("dismiss")
  end
end
