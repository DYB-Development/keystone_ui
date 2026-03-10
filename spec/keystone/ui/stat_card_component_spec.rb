# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::StatCardComponent do
  it "returns card classes" do
    component = described_class.new(label: "Total", value: "42")

    expect(component.classes).to include("rounded-xl")
    expect(component.classes).to include("border")
    expect(component.classes).to include("p-6")
  end

  it "exposes label and value" do
    component = described_class.new(label: "Published", value: "1,234")

    expect(component.label).to eq("Published")
    expect(component.value).to eq("1,234")
  end

  it "defaults to neutral variant" do
    component = described_class.new(label: "Count", value: "0")

    expect(component.value_classes).to include("text-gray-900")
  end

  it "maps variant to value color" do
    %i[success danger warning].each do |variant|
      component = described_class.new(label: "X", value: "0", variant: variant)
      expect(component.value_classes).to include(described_class::VARIANT_CLASSES[variant])
    end
  end

  it "exposes label classes" do
    component = described_class.new(label: "X", value: "0")

    expect(component.label_classes).to include("text-sm")
  end

  it "exposes optional suffix" do
    component = described_class.new(label: "Latency", value: "42", suffix: "ms")

    expect(component.suffix).to eq("ms")
    expect(component.suffix?).to be true
  end

  it "returns false for suffix? when not provided" do
    component = described_class.new(label: "Count", value: "5")

    expect(component.suffix?).to be false
  end

  it "uses semantic accent classes for info variant" do
    component = described_class.new(label: "X", value: "0", variant: :info)

    expect(component.value_classes).to include("text-accent-600")
    expect(component.value_classes).to include("dark:text-accent-400")
  end
end
