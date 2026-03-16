# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::MobileActionsComponent do
  it "has WRAPPER_CLASSES with relative positioning and lg:hidden" do
    expect(described_class::WRAPPER_CLASSES).to include("relative")
    expect(described_class::WRAPPER_CLASSES).to include("lg:hidden")
  end

  it "has BUTTON_CLASSES with gray text styling" do
    expect(described_class::BUTTON_CLASSES).to include("text-gray-500")
  end

  it "has DROPDOWN_CLASSES with hidden and positioning" do
    expect(described_class::DROPDOWN_CLASSES).to include("hidden")
    expect(described_class::DROPDOWN_CLASSES).to include("absolute")
    expect(described_class::DROPDOWN_CLASSES).to include("z-50")
  end

  it "has DROPDOWN_CLASSES with rounded and shadow styling" do
    expect(described_class::DROPDOWN_CLASSES).to include("rounded-md")
    expect(described_class::DROPDOWN_CLASSES).to include("shadow-lg")
  end

  it "has a frozen ELLIPSIS_ICON SVG" do
    expect(described_class::ELLIPSIS_ICON).to be_frozen
    expect(described_class::ELLIPSIS_ICON).to include("<svg")
  end

  it "provides dropdown Stimulus controller data" do
    component = described_class.new

    expect(component.wrapper_data[:controller]).to eq("dropdown")
  end
end
