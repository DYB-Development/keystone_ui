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

  context "accent theming" do
    after { KeystoneUi.reset_configuration! }

    it "uses blue hover text by default" do
      component = described_class.new

      expect(component.button_classes).to include("hover:text-blue-600")
    end

    it "uses emerald hover text when configured" do
      KeystoneUi.configure { |c| c.accent = :emerald }
      component = described_class.new

      expect(component.button_classes).to include("hover:text-emerald-600")
      expect(component.button_classes).not_to include("blue")
    end
  end

  context "surface theming" do
    after { KeystoneUi.reset_configuration! }

    it "uses zinc surface by default" do
      component = described_class.new

      expect(component.item_classes).to include("dark:border-zinc-700")
      expect(component.button_classes).to include("text-gray-900")
      expect(component.answer_classes).to include("text-gray-600")
      expect(component.icon_classes).to include("text-gray-400")
    end

    it "uses slate surface when configured" do
      KeystoneUi.configure { |c| c.surface = :slate }
      component = described_class.new

      expect(component.item_classes).to include("dark:border-slate-700")
      expect(component.button_classes).to include("text-slate-900")
      expect(component.answer_classes).to include("text-slate-600")
      expect(component.icon_classes).to include("text-slate-400")
    end
  end
end
