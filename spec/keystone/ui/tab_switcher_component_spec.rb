# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::TabSwitcherComponent do
  it "returns base wrapper classes" do
    component = described_class.new(tabs: ["One", "Two"])

    expect(component.classes).to eq("mb-8 flex flex-wrap justify-center gap-2")
  end

  it "stores tab labels" do
    component = described_class.new(tabs: ["Alpha", "Beta", "Gamma"])

    expect(component.tabs).to eq(["Alpha", "Beta", "Gamma"])
  end

  it "exposes tab button classes" do
    component = described_class.new(tabs: ["A"])

    expect(component.tab_classes).to include("rounded-lg")
    expect(component.tab_classes).to include("font-semibold")
  end

  it "uses semantic accent classes for active tab state" do
    component = described_class.new(tabs: ["A"])

    expect(component.tab_classes).to include("data-[active]:bg-accent-500/10")
    expect(component.tab_classes).to include("data-[active]:text-accent-600")
  end

  it "exposes panel_classes as hidden" do
    component = described_class.new(tabs: ["A"])

    expect(component.panel_classes).to eq("hidden")
  end

  it "includes dark mode accent classes for active tab" do
    component = described_class.new(tabs: ["A"])

    expect(component.tab_classes).to include("dark:data-[active]:text-accent-400")
  end

  it "wires the tab-switcher Stimulus controller" do
    component = described_class.new(tabs: ["A", "B"])

    expect(component.wrapper_data[:controller]).to eq("tab-switcher")
  end
end
