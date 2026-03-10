# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::SectionComponent do
  it "defaults to mt-6 spacing" do
    component = described_class.new

    expect(component.spacing_class).to eq("mt-6")
  end

  it "maps each spacing value correctly" do
    expect(described_class.new(spacing: :sm).spacing_class).to eq("mt-4")
    expect(described_class.new(spacing: :md).spacing_class).to eq("mt-6")
    expect(described_class.new(spacing: :lg).spacing_class).to eq("mt-8")
  end

  it "returns true for header? when title is present" do
    component = described_class.new(title: "Users")

    expect(component.header?).to be true
  end

  it "returns false for header? when title is nil" do
    component = described_class.new

    expect(component.header?).to be false
  end

  it "stores the action hash" do
    action = { label: "View all", href: "/users" }
    component = described_class.new(title: "Users", action: action)

    expect(component.instance_variable_get(:@action)).to eq(action)
  end

  it "has HEADER_CLASSES with flex layout and spacing" do
    expect(described_class::HEADER_CLASSES).to include("flex")
    expect(described_class::HEADER_CLASSES).to include("justify-between")
    expect(described_class::HEADER_CLASSES).to include("mb-4")
  end

  it "has TITLE_CLASSES with semibold text styling" do
    expect(described_class::TITLE_CLASSES).to include("font-semibold")
    expect(described_class::TITLE_CLASSES).to include("text-lg")
  end

  it "uses semantic accent classes for action link" do
    component = described_class.new(title: "Users")

    expect(component.action_classes).to include("text-accent-600")
    expect(component.action_classes).to include("hover:text-accent-900")
    expect(component.action_classes).to include("dark:text-accent-400")
    expect(component.action_classes).to include("dark:hover:text-accent-300")
  end
end
