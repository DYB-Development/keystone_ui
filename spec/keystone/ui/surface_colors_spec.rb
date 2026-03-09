# frozen_string_literal: true

require "spec_helper"

RSpec.describe KeystoneUi::SurfaceColors do
  after { KeystoneUi.reset_configuration! }

  it "returns zinc palette by default" do
    expect(described_class[:heading]).to eq("text-gray-900 dark:text-white")
  end

  it "returns named preset palette" do
    KeystoneUi.configure { |c| c.surface = :slate }

    expect(described_class[:heading]).to eq("text-slate-900 dark:text-white")
    expect(described_class[:body]).to eq("text-slate-500 dark:text-slate-400")
  end

  context "with CurrentAttributes override" do
    before do
      stub_const("KeystoneUi::Current", Class.new do
        class << self
          attr_accessor :accent_override, :surface_override
        end
      end)
    end

    after { KeystoneUi::Current.surface_override = nil }

    it "uses surface_override when set" do
      KeystoneUi::Current.surface_override = :stone

      expect(described_class[:heading]).to eq("text-stone-900 dark:text-white")
      expect(described_class[:body]).to eq("text-stone-500 dark:text-stone-400")
    end

    it "falls back to configuration when override is nil" do
      KeystoneUi.configure { |c| c.surface = :slate }
      KeystoneUi::Current.surface_override = nil

      expect(described_class[:heading]).to eq("text-slate-900 dark:text-white")
    end

    it "override takes precedence over configuration" do
      KeystoneUi.configure { |c| c.surface = :slate }
      KeystoneUi::Current.surface_override = :neutral

      expect(described_class[:heading]).to eq("text-neutral-900 dark:text-white")
    end
  end
end
