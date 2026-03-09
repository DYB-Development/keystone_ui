# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::BadgeComponent do
  it "returns base classes" do
    component = described_class.new(label: "Active")

    expect(component.classes).to include("rounded-full")
    expect(component.classes).to include("text-xs")
    expect(component.classes).to include("font-medium")
  end

  it "exposes label" do
    component = described_class.new(label: "Published")

    expect(component.label).to eq("Published")
  end

  it "defaults to neutral variant" do
    component = described_class.new(label: "X")

    expect(component.classes).to include(described_class::VARIANT_CLASSES[:neutral])
  end

  it "maps each variant to its classes" do
    %i[neutral success danger warning].each do |variant|
      component = described_class.new(label: "X", variant: variant)
      expect(component.classes).to include(described_class::VARIANT_CLASSES[variant])
    end
  end

  context "with custom accent" do
    after { KeystoneUi.reset_configuration! }

    it "uses accent colors for info variant" do
      KeystoneUi.configure { |c| c.accent = :emerald }
      component = described_class.new(label: "X", variant: :info)

      expect(component.classes).to include("bg-emerald-100")
      expect(component.classes).to include("text-emerald-700")
      expect(component.classes).not_to include("bg-blue-100")
    end
  end
end
