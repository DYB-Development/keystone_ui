# frozen_string_literal: true

require "test_helper"
require "tmpdir"
require "rails"
require_relative "../../lib/keystone_ui/engine"

class KeystoneUi::EngineBootTest < Minitest::Test
  def test_removes_the_leftover_stylesheet_from_the_host_when_the_host_boots
    Dir.mktmpdir do |root|
      leftover = Pathname.new(root).join("app/assets/builds/tailwind/keystone_ui_engine.css")
      leftover.dirname.mkpath
      leftover.write(%(@import "/old/gem/engine.css";))

      boot_with_root(Pathname.new(root))

      refute leftover.exist?
    end
  end

  private

  def boot_with_root(root)
    host = Struct.new(:root).new(root)
    KeystoneUi::Engine.initializers
      .find { |initializer| initializer.name == "keystone_ui.remove_leftover_stylesheet" }
      .bind(KeystoneUi::Engine.instance)
      .run(host)
  end
end
