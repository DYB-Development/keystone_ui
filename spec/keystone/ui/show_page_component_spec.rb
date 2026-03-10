# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::ShowPageComponent do
  it "returns true for subtitle? when subtitle is provided" do
    component = described_class.new(title: "Invoice #42", back_url: "/invoices", subtitle: "Paid")

    expect(component.subtitle?).to be true
  end

  it "returns false for subtitle? when subtitle is not provided" do
    component = described_class.new(title: "Invoice #42", back_url: "/invoices")

    expect(component.subtitle?).to be false
  end

  it "has DESKTOP_WRAPPER_CLASSES hidden on mobile" do
    expect(described_class::DESKTOP_WRAPPER_CLASSES).to include("hidden")
    expect(described_class::DESKTOP_WRAPPER_CLASSES).to include("md:block")
  end

  it "has TITLE_CLASSES constant" do
    expect(described_class::TITLE_CLASSES).to include("text-2xl")
    expect(described_class::TITLE_CLASSES).to include("font-semibold")
  end

  it "has SUBTITLE_CLASSES constant" do
    expect(described_class::SUBTITLE_CLASSES).to include("text-sm")
    expect(described_class::SUBTITLE_CLASSES).to include("text-gray-500")
  end
end
