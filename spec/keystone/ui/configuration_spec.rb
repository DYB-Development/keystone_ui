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
end
