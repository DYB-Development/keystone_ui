# frozen_string_literal: true

require_relative "lib/keystone_ui/version"

Gem::Specification.new do |spec|
  spec.name = "keystone_ui"
  spec.version = KeystoneUi::VERSION
  spec.authors = [ "Tyler Schneider" ]
  spec.email = [ "tylercschneider@gmail.com" ]

  spec.summary = "Reusable UI component system for Rails applications."
  spec.description = "Reusable UI component system for Rails applications using ViewComponent."
  spec.homepage = "https://github.com/DYB-Development/keystone_ui"
  spec.license = "MIT"

  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["documentation_uri"] = "#{spec.homepage}#readme"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.required_ruby_version = ">= 3.2.0"

  spec.files = Dir["lib/**/*", "app/**/*", "config/**/*"]
  spec.require_paths = [ "lib" ]

  spec.add_dependency "view_component", ">= 2.0"

  spec.post_install_message = <<~MSG
    Keystone UI installed!

    Prerequisites: tailwindcss-rails v4+

    Run the install generator for setup instructions:
      rails generate keystone:install
  MSG
end
