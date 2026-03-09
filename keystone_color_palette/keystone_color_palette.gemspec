# frozen_string_literal: true

require_relative "lib/keystone_color_palette/version"

Gem::Specification.new do |spec|
  spec.name = "keystone_color_palette"
  spec.version = KeystoneColorPalette::VERSION
  spec.authors = ["Tyler Schneider"]
  spec.email = ["tylercschneider@gmail.com"]

  spec.summary = "Per-user color palette settings for Keystone UI."
  spec.description = "A companion gem for keystone_ui that provides a settings interface for users to choose and persist their color palette preferences."
  spec.homepage = "https://github.com/tylercschneider/keystone_color_palette"
  spec.license = "MIT"

  spec.metadata["source_code_uri"] = "https://github.com/tylercschneider/keystone_color_palette"

  spec.required_ruby_version = ">= 3.1.0"

  spec.files = Dir["lib/**/*", "app/**/*", "config/**/*", "db/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency "keystone_ui", ">= 0.4.1"
  spec.add_dependency "activerecord", ">= 7.0"
  spec.add_dependency "activesupport", ">= 7.0"

  spec.post_install_message = <<~MSG
    Keystone Color Palette installed!

    Run the install generator for setup instructions:
      rails generate keystone_color_palette:install
  MSG
end
