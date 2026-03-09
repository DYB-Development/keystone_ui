# frozen_string_literal: true

require "spec_helper"

RSpec.describe Keystone::Ui::FeatureGridComponent do
  let(:features) do
    [
      { icon: "X", title: "Fast", description: "Very fast." },
      { icon: "Y", title: "Safe", description: "Very safe." }
    ]
  end

  it "returns wrapper classes" do
    component = described_class.new(title: "Features", features: features)

    expect(component.classes).to include("grid")
    expect(component.classes).to include("gap-6")
  end

  it "exposes title and subtitle" do
    component = described_class.new(title: "Features", subtitle: "The best.", features: features)

    expect(component.title).to eq("Features")
    expect(component.subtitle).to eq("The best.")
    expect(component.subtitle?).to be true
  end

  it "returns false for subtitle? when not provided" do
    component = described_class.new(title: "X", features: features)

    expect(component.subtitle?).to be false
  end

  it "stores features" do
    component = described_class.new(title: "X", features: features)

    expect(component.features).to eq(features)
  end

  it "exposes card classes" do
    component = described_class.new(title: "X", features: features)

    expect(component.card_classes).to include("rounded-xl")
    expect(component.card_classes).to include("border")
    expect(component.card_classes).to include("p-6")
  end

  it "exposes icon wrapper classes" do
    component = described_class.new(title: "X", features: features)

    expect(component.icon_classes).to include("rounded-lg")
  end

  context "accent theming" do
    after { KeystoneUi.reset_configuration! }

    it "uses blue accent by default" do
      component = described_class.new(title: "X", features: features)

      expect(component.card_classes).to include("hover:border-blue-500/50")
      expect(component.icon_classes).to include("bg-blue-500/10")
      expect(component.icon_classes).to include("text-blue-600")
    end

    it "uses emerald accent when configured" do
      KeystoneUi.configure { |c| c.accent = :emerald }
      component = described_class.new(title: "X", features: features)

      expect(component.card_classes).to include("hover:border-emerald-500/50")
      expect(component.icon_classes).to include("bg-emerald-500/10")
      expect(component.icon_classes).to include("text-emerald-600")
      expect(component.card_classes).not_to include("blue")
      expect(component.icon_classes).not_to include("blue")
    end
  end
end
