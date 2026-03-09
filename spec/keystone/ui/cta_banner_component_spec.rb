# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::CtaBannerComponent do
  it "returns card classes" do
    component = described_class.new(title: "Get Started")

    expect(component.classes).to include("rounded-2xl")
    expect(component.classes).to include("border")
    expect(component.classes).to include("text-center")
  end

  it "exposes title" do
    component = described_class.new(title: "Ready?")

    expect(component.title).to eq("Ready?")
  end

  it "exposes subtitle when provided" do
    component = described_class.new(title: "X", subtitle: "Get started today.")

    expect(component.subtitle?).to be true
    expect(component.subtitle).to eq("Get started today.")
  end

  it "returns false for subtitle? when not provided" do
    component = described_class.new(title: "X")

    expect(component.subtitle?).to be false
  end

  it "exposes title and subtitle classes" do
    component = described_class.new(title: "X")

    expect(component.title_classes).to include("font-bold")
  end

  it "exposes actions wrapper classes" do
    component = described_class.new(title: "X")

    expect(component.actions_classes).to include("flex")
    expect(component.actions_classes).to include("justify-center")
  end

  context "surface theming" do
    after { KeystoneUi.reset_configuration! }

    it "uses zinc surface by default" do
      component = described_class.new(title: "X", subtitle: "Sub")

      expect(component.classes).to include("dark:border-zinc-700")
      expect(component.classes).to include("dark:bg-zinc-800")
      expect(component.title_classes).to include("text-gray-900")
      expect(component.subtitle_classes).to include("text-gray-500")
    end

    it "uses slate surface when configured" do
      KeystoneUi.configure { |c| c.surface = :slate }
      component = described_class.new(title: "X", subtitle: "Sub")

      expect(component.classes).to include("dark:border-slate-700")
      expect(component.classes).to include("dark:bg-slate-800")
      expect(component.title_classes).to include("text-slate-900")
      expect(component.subtitle_classes).to include("text-slate-500")
    end
  end
end
