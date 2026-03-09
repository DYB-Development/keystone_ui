# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::HeroComponent do
  it "exposes title" do
    component = described_class.new(title: "Welcome")

    expect(component.title).to eq("Welcome")
  end

  it "exposes subtitle when provided" do
    component = described_class.new(title: "X", subtitle: "Subtext here.")

    expect(component.subtitle?).to be true
    expect(component.subtitle).to eq("Subtext here.")
  end

  it "returns false for subtitle? when not provided" do
    component = described_class.new(title: "X")

    expect(component.subtitle?).to be false
  end

  it "exposes badge when provided" do
    component = described_class.new(title: "X", badge: "New")

    expect(component.badge?).to be true
    expect(component.badge).to eq("New")
  end

  it "returns false for badge? when not provided" do
    component = described_class.new(title: "X")

    expect(component.badge?).to be false
  end

  it "exposes wrapper classes" do
    component = described_class.new(title: "X")

    expect(component.classes).to include("min-h-screen")
  end

  it "exposes title classes" do
    component = described_class.new(title: "X")

    expect(component.title_classes).to include("font-bold")
    expect(component.title_classes).to include("tracking-tight")
  end

  it "supports centered layout" do
    component = described_class.new(title: "X", layout: :centered)

    expect(component.content_classes).to include("text-center")
  end

  it "defaults to split layout" do
    component = described_class.new(title: "X")

    expect(component.content_classes).to include("lg:grid-cols-2")
  end

  context "accent theming" do
    after { KeystoneUi.reset_configuration! }

    it "uses blue accent badge classes by default" do
      component = described_class.new(title: "X", badge: "New")

      expect(component.badge_classes).to include("border-blue-500/20")
      expect(component.badge_classes).to include("text-blue-600")
    end

    it "uses emerald accent badge classes when configured" do
      KeystoneUi.configure { |c| c.accent = :emerald }
      component = described_class.new(title: "X", badge: "New")

      expect(component.badge_classes).to include("border-emerald-500/20")
      expect(component.badge_classes).to include("text-emerald-600")
      expect(component.badge_classes).not_to include("blue")
    end
  end

  context "surface theming" do
    after { KeystoneUi.reset_configuration! }

    it "uses gray/zinc surface by default" do
      component = described_class.new(title: "X", subtitle: "Sub")

      expect(component.title_classes).to include("text-gray-900")
      expect(component.subtitle_classes).to include("text-gray-500")
    end

    it "uses slate surface when configured" do
      KeystoneUi.configure { |c| c.surface = :slate }
      component = described_class.new(title: "X", subtitle: "Sub")

      expect(component.title_classes).to include("text-slate-900")
      expect(component.title_classes).not_to include("text-gray-900")
      expect(component.subtitle_classes).to include("text-slate-500")
      expect(component.subtitle_classes).to include("dark:text-slate-400")
    end
  end
end
