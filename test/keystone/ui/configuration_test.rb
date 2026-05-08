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
end
