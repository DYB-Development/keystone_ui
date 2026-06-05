# frozen_string_literal: true

require "test_helper"

class KeystoneUi::ImportmapTest < Minitest::Test
  ROOT = File.expand_path("../..", __dir__)

  def test_every_controller_has_an_importmap_pin
    pins = File.read(File.join(ROOT, "config/importmap.rb"))
    controllers = Dir.glob(File.join(ROOT, "app/assets/javascripts/keystone_ui/*_controller.js"))
      .map { |file| File.basename(file, ".js") }

    missing = controllers.reject { |name| pins.include?("keystone_ui/#{name}") }

    assert_empty missing, "controllers missing an importmap pin: #{missing.join(", ")}"
  end
end
