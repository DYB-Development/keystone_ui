# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::NavDropdownComponent do
  it "stores title" do
    component = described_class.new(title: "Plan", area: :plan, active: false)

    expect(component.title).to eq("Plan")
  end

  it "includes active class on trigger when active" do
    component = described_class.new(title: "Plan", area: :plan, active: true)

    expect(component.trigger_classes).to include("active")
  end

  it "excludes active class on trigger when not active" do
    component = described_class.new(title: "Plan", area: :plan, active: false)

    expect(component.trigger_classes).not_to include("active")
  end

  it "includes trigger base class when not active" do
    component = described_class.new(title: "Plan", area: :plan, active: false)

    expect(component.trigger_classes).to eq("nav-dropdown-trigger")
  end

  it "exposes area" do
    component = described_class.new(title: "Plan", area: :plan, active: false)

    expect(component.area).to eq(:plan)
  end

  it "has WRAPPER_CLASSES with nav-dropdown" do
    expect(described_class::WRAPPER_CLASSES).to eq("nav-dropdown")
  end

  it "has MENU_CLASSES with hidden" do
    expect(described_class::MENU_CLASSES).to include("hidden")
    expect(described_class::MENU_CLASSES).to include("nav-dropdown-menu")
  end

  it "has a frozen CARET_ICON SVG" do
    expect(described_class::CARET_ICON).to be_frozen
    expect(described_class::CARET_ICON).to include("<svg")
  end
end
