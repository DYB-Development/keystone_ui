# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::ThemeToggleComponentTest < Minitest::Test
  def test_shows_system_as_pressed_when_no_theme_is_chosen
    assert Keystone::Ui::ThemeToggleComponent.new.pressed?("system")
  end
end
