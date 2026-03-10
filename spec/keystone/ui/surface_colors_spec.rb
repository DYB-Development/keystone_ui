# frozen_string_literal: true

require "spec_helper"

RSpec.describe KeystoneUi::SurfaceColors do
  after { KeystoneUi.reset_configuration! }

  context "with CurrentAttributes override" do
    before do
      stub_const("KeystoneUi::Current", Class.new {
        class << self
          attr_accessor :accent_override, :surface_override
        end
      })
    end

    after { KeystoneUi::Current.surface_override = nil }

    it "uses surface_override when set" do
      KeystoneUi::Current.surface_override = :stone

      expect(described_class[:heading]).to eq("text-stone-900 dark:text-white")
      expect(described_class[:body]).to eq("text-stone-500 dark:text-stone-400")
    end
  end
end
