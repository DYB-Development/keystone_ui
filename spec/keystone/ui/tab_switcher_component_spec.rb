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

  context "with custom accent" do
    after { KeystoneUi.reset_configuration! }

    it "uses accent colors for active tab state" do
      KeystoneUi.configure { |c| c.accent = :emerald }
      component = described_class.new(tabs: ["A"])

      expect(component.tab_classes).to include("text-emerald-600")
      expect(component.tab_classes).not_to include("text-blue-600")
    end
  end
end
