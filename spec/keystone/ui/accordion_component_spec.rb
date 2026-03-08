# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::AccordionComponent do
  it "returns base wrapper classes" do
    component = described_class.new

    expect(component.classes).to eq("flex flex-col gap-4")
  end

  it "stores items with question and answer" do
    items = [
      { question: "Q1?", answer: "A1." },
      { question: "Q2?", answer: "A2." }
    ]
    component = described_class.new(items: items)

    expect(component.items).to eq(items)
  end

  it "exposes item classes" do
    component = described_class.new

    expect(component.item_classes).to include("rounded-xl")
    expect(component.item_classes).to include("border")
  end

  it "exposes button classes" do
    component = described_class.new

    expect(component.button_classes).to include("flex")
    expect(component.button_classes).to include("w-full")
    expect(component.button_classes).to include("text-left")
  end

  it "exposes answer panel classes" do
    component = described_class.new

    expect(component.answer_classes).to include("hidden")
  end
end
