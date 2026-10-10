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

  def test_checking_the_hosts_looks_stops_boot_on_a_default_look_that_is_not_registered
    KeystoneUi.configure { |config| config.default_look = :missing }

    assert_raises(KeystoneUi::LookCheck::Error) { KeystoneUi::Engine.check_looks }
  ensure
    KeystoneUi.reset_configuration!
  end

  def test_checking_the_hosts_navigation_stops_boot_on_a_tab_with_no_label
    KeystoneUi.configure do |config|
      config.navigation_group("Work") { |group| group.tab :deals, label: nil, href: "/deals", permitted: ->(_view) { true } }
    end

    assert_raises(KeystoneUi::NavigationCheck::Error) { KeystoneUi::Engine.check_navigation }
  ensure
    KeystoneUi.reset_configuration!
  end

  def test_checking_the_hosts_navigation_passes_when_the_host_declares_none
    KeystoneUi.reset_configuration!

    assert_nil KeystoneUi::Engine.check_navigation
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
