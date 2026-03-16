# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::ModalComponent do
  it "exposes backdrop classes" do
    component = described_class.new(title: "Details")

    expect(component.backdrop_classes).to include("fixed")
    expect(component.backdrop_classes).to include("inset-0")
    expect(component.backdrop_classes).to include("z-50")
  end

  it "exposes panel classes" do
    component = described_class.new(title: "Details")

    expect(component.panel_classes).to include("rounded-xl")
    expect(component.panel_classes).to include("border")
  end

  it "exposes title" do
    component = described_class.new(title: "Event Payload")

    expect(component.title).to eq("Event Payload")
  end

  it "exposes title classes" do
    component = described_class.new(title: "X")

    expect(component.title_classes).to include("font-semibold")
  end

  it "exposes close button classes" do
    component = described_class.new(title: "X")

    expect(component.close_button_classes).to include("hover:text-gray-600")
  end

  it "defaults to md size" do
    component = described_class.new(title: "X")

    expect(component.size_class).to eq("max-w-lg")
  end

  it "accepts sm size" do
    component = described_class.new(title: "X", size: :sm)

    expect(component.size_class).to eq("max-w-sm")
  end

  it "accepts lg size" do
    component = described_class.new(title: "X", size: :lg)

    expect(component.size_class).to eq("max-w-2xl")
  end

  it "accepts xl size" do
    component = described_class.new(title: "X", size: :xl)

    expect(component.size_class).to eq("max-w-4xl")
  end

  it "provides Stimulus controller data for open/close behavior" do
    component = described_class.new(title: "Confirm")

    expect(component.wrapper_data[:controller]).to eq("modal")
  end
end
