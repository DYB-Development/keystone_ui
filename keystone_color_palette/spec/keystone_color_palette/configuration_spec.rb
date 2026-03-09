# frozen_string_literal: true

require "spec_helper"

RSpec.describe KeystoneColorPalette::Configuration do
  after { KeystoneColorPalette.reset_configuration! }

  it "has sensible defaults" do
    config = KeystoneColorPalette.configuration

    expect(config.owner_class_name).to eq("User")
    expect(config.current_owner_method).to eq(:current_user)
    expect(config.default_template).to eq(:ocean)
  end

  it "allows configuration via block" do
    KeystoneColorPalette.configure do |c|
      c.owner_class_name = "Account"
      c.current_owner_method = :current_account
      c.default_template = :forest
    end

    config = KeystoneColorPalette.configuration
    expect(config.owner_class_name).to eq("Account")
    expect(config.current_owner_method).to eq(:current_account)
    expect(config.default_template).to eq(:forest)
  end

  it "resets to defaults" do
    KeystoneColorPalette.configure { |c| c.owner_class_name = "Admin" }
    KeystoneColorPalette.reset_configuration!

    expect(KeystoneColorPalette.configuration.owner_class_name).to eq("User")
  end
end
