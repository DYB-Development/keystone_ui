# frozen_string_literal: true

require "test_helper"
require_relative "../../../lib/keystone_ui/theme_choice"

class Keystone::Ui::ThemeToggleComponentTest < Minitest::Test
  def test_shows_light_as_pressed_when_no_theme_is_chosen
    assert Keystone::Ui::ThemeToggleComponent.new.pressed?("light")
  end

  def test_shows_the_chosen_theme_as_pressed
    assert Keystone::Ui::ThemeToggleComponent.new(current: "dark").pressed?("dark")
  end

  def test_shows_light_as_pressed_when_the_chosen_theme_is_unknown
    assert Keystone::Ui::ThemeToggleComponent.new(current: "purple").pressed?("light")
  end

  def test_offers_light_dark_and_system_options_in_that_order
    assert_equal [ [ "Light", "light" ], [ "Dark", "dark" ], [ "System", "system" ] ], Keystone::Ui::ThemeToggleComponent.new.options
  end
end
