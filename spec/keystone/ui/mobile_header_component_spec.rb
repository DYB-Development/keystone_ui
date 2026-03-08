# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::MobileHeaderComponent do
  it "exposes title" do
    component = described_class.new(title: "Invoice #42", back_url: "/invoices")

    expect(component.instance_variable_get(:@title)).to eq("Invoice #42")
  end

  it "exposes back_url" do
    component = described_class.new(title: "Invoice #42", back_url: "/invoices")

    expect(component.instance_variable_get(:@back_url)).to eq("/invoices")
  end

  it "stores subtitle when provided" do
    component = described_class.new(title: "Invoice #42", back_url: "/invoices", subtitle: "Draft")

    expect(component.instance_variable_get(:@subtitle)).to eq("Draft")
  end

  it "has WRAPPER_CLASSES hidden on large screens" do
    expect(described_class::WRAPPER_CLASSES).to include("lg:hidden")
  end

  it "has SUBTITLE_CLASSES with small text and centering" do
    expect(described_class::SUBTITLE_CLASSES).to include("text-xs")
    expect(described_class::SUBTITLE_CLASSES).to include("text-center")
    expect(described_class::SUBTITLE_CLASSES).to include("truncate")
  end

  it "has BACK_LINK_CLASSES with gray text styling" do
    expect(described_class::BACK_LINK_CLASSES).to include("text-gray-500")
  end

  it "has TITLE_CLASSES with centered positioning and truncation" do
    expect(described_class::TITLE_CLASSES).to include("absolute")
    expect(described_class::TITLE_CLASSES).to include("-translate-x-1/2")
    expect(described_class::TITLE_CLASSES).to include("truncate")
    expect(described_class::TITLE_CLASSES).to include("font-semibold")
  end

  it "hides title on large screens with lg:hidden" do
    expect(described_class::TITLE_CLASSES).to include("lg:hidden")
  end

  it "has DROPDOWN_CLASSES with hidden and positioning" do
    expect(described_class::DROPDOWN_CLASSES).to include("hidden")
    expect(described_class::DROPDOWN_CLASSES).to include("absolute")
    expect(described_class::DROPDOWN_CLASSES).to include("z-50")
  end

  it "has frozen SVG icons" do
    expect(described_class::BACK_ICON).to be_frozen
    expect(described_class::BACK_ICON).to include("<svg")
    expect(described_class::ELLIPSIS_ICON).to be_frozen
    expect(described_class::ELLIPSIS_ICON).to include("<svg")
  end
end
