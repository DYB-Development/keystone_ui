# frozen_string_literal: true

require "test_helper"

class KeystoneUi::ConfigurationTest < Minitest::Test
  def teardown
    KeystoneUi.reset_configuration!
  end

  def test_defaults_accent_to_blue
    assert_equal :blue, KeystoneUi.configuration.accent
  end

  def test_defaults_surface_to_zinc
    assert_equal :zinc, KeystoneUi.configuration.surface
  end

  def test_allows_setting_accent_via_configure_block
    KeystoneUi.configure { |c| c.accent = :emerald }

    assert_equal :emerald, KeystoneUi.configuration.accent
  end

  def test_allows_setting_surface_via_configure_block
    KeystoneUi.configure { |c| c.surface = :slate }

    assert_equal :slate, KeystoneUi.configuration.surface
  end

  def test_supplies_no_theme_mode_when_no_gem_supplies_one
    assert_nil KeystoneUi.configuration.supplied_theme_mode(Object.new)
  end

  def test_supplies_the_theme_mode_a_registered_supplier_returns_for_the_view
    view = Struct.new(:saved_mode).new("dark")
    KeystoneUi.configure { |c| c.theme_mode_supplier = ->(from) { from.saved_mode } }

    assert_equal "dark", KeystoneUi.configuration.supplied_theme_mode(view)
  end

  def test_starts_with_no_tailwind_files_registered_for_import
    assert_equal [], KeystoneUi::Configuration.new.tailwind_imports
  end
end
