# frozen_string_literal: true

require "spec_helper"

RSpec.describe KeystoneUi::AccentColors do
  after { KeystoneUi.reset_configuration! }

  it "returns blue palette by default" do
    expect(described_class[:text]).to eq("text-blue-600")
  end

  it "returns named preset palette" do
    KeystoneUi.configure { |c| c.accent = :emerald }

    expect(described_class[:text]).to eq("text-emerald-600")
  end

  it "falls back to blue defaults for keys missing from custom hash" do
    KeystoneUi.configure do |c|
      c.accent = {
        border: "border-[#A0333D]/20",
        bg: "bg-[#A0333D]/10",
        text: "text-[#D4636D]",
        dark_text: "text-[#D4636D]",
        hover_border: "hover:border-[#A0333D]/50",
        dark_hover_border: "hover:border-[#A0333D]/50",
        hover_text: "hover:text-[#E07A83]",
        dark_hover_text: "hover:text-[#E07A83]"
      }
    end

    # Provided keys use custom values
    expect(described_class[:text]).to eq("text-[#D4636D]")
    # Keys not in the custom hash fall back to blue
    expect(described_class[:badge_bg]).to eq("bg-blue-100")
  end
end
