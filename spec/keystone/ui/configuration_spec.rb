# frozen_string_literal: true

require "spec_helper"

RSpec.describe KeystoneUi::Configuration do
  after { KeystoneUi.reset_configuration! }

  it "defaults accent to :blue" do
    expect(KeystoneUi.configuration.accent).to eq(:blue)
  end

  it "defaults surface to :zinc" do
    expect(KeystoneUi.configuration.surface).to eq(:zinc)
  end

  it "allows setting accent via configure block" do
    KeystoneUi.configure { |c| c.accent = :emerald }

    expect(KeystoneUi.configuration.accent).to eq(:emerald)
  end

  it "allows setting surface via configure block" do
    KeystoneUi.configure { |c| c.surface = :slate }

    expect(KeystoneUi.configuration.surface).to eq(:slate)
  end
end
