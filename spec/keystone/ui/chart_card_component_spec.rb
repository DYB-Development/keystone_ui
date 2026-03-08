# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::ChartCardComponent do
  it "returns card classes" do
    component = described_class.new(title: "Throughput")

    expect(component.classes).to include("rounded-xl")
    expect(component.classes).to include("border")
    expect(component.classes).to include("p-6")
  end

  it "exposes title" do
    component = described_class.new(title: "Latency")

    expect(component.title).to eq("Latency")
  end

  it "exposes title classes" do
    component = described_class.new(title: "X")

    expect(component.title_classes).to include("text-sm")
    expect(component.title_classes).to include("font-medium")
  end

  it "defaults chart height to h-64" do
    component = described_class.new(title: "X")

    expect(component.chart_height_class).to eq("h-64")
  end

  it "accepts custom height" do
    component = described_class.new(title: "X", height: :lg)

    expect(component.chart_height_class).to eq("h-96")
  end
end
