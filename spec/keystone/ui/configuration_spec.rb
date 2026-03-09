# frozen_string_literal: true

require "spec_helper"

RSpec.describe KeystoneUi::Configuration do
  after { KeystoneUi.reset_configuration! }

  it "defaults accent to :blue" do
    expect(KeystoneUi.configuration.accent).to eq(:blue)
  end

  it "allows setting accent via configure block" do
    KeystoneUi.configure { |c| c.accent = :emerald }

    expect(KeystoneUi.configuration.accent).to eq(:emerald)
  end

  it "rejects unsupported accent colors" do
    expect {
      KeystoneUi.configure { |c| c.accent = :pink }
    }.to raise_error(ArgumentError, /unsupported accent/i)
  end

  it "supports emerald accent" do
    KeystoneUi.configure { |c| c.accent = :emerald }

    expect(KeystoneUi.configuration.accent).to eq(:emerald)
  end

  it "supports cyan accent" do
    KeystoneUi.configure { |c| c.accent = :cyan }

    expect(KeystoneUi.configuration.accent).to eq(:cyan)
  end

  it "defaults surface to :zinc" do
    expect(KeystoneUi.configuration.surface).to eq(:zinc)
  end

  it "allows setting surface via configure block" do
    KeystoneUi.configure { |c| c.surface = :slate }

    expect(KeystoneUi.configuration.surface).to eq(:slate)
  end

  it "rejects unsupported surface colors" do
    expect {
      KeystoneUi.configure { |c| c.surface = :purple }
    }.to raise_error(ArgumentError, /unsupported surface/i)
  end

  it "accepts a custom accent hash with all required keys" do
    custom = {
      border: "border-[#A0333D]/20",
      bg: "bg-[#A0333D]/10",
      text: "text-[#D4636D]",
      dark_text: "text-[#D4636D]",
      hover_border: "hover:border-[#A0333D]/50",
      dark_hover_border: "hover:border-[#A0333D]/50",
      hover_text: "hover:text-[#E07A83]",
      dark_hover_text: "hover:text-[#E07A83]"
    }

    KeystoneUi.configure { |c| c.accent = custom }

    expect(KeystoneUi.configuration.accent).to eq(custom)
  end

  it "rejects a custom accent hash missing required keys" do
    expect {
      KeystoneUi.configure { |c| c.accent = { text: "text-red-500" } }
    }.to raise_error(ArgumentError, /missing required keys/i)
  end

  it "rejects a custom accent hash with non-string values" do
    custom = {
      border: "border-[#A0333D]/20",
      bg: nil,
      text: "text-[#D4636D]",
      dark_text: "text-[#D4636D]",
      hover_border: "hover:border-[#A0333D]/50",
      dark_hover_border: "hover:border-[#A0333D]/50",
      hover_text: "hover:text-[#E07A83]",
      dark_hover_text: "hover:text-[#E07A83]"
    }

    expect {
      KeystoneUi.configure { |c| c.accent = custom }
    }.to raise_error(ArgumentError, /must be strings/i)
  end
end
