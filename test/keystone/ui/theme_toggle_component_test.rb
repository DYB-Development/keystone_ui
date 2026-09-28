# frozen_string_literal: true

require "test_helper"
require_relative "../../../lib/keystone_ui/theme_choice"

class Keystone::Ui::ThemeToggleComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

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

  def test_option_classes_render_the_ks_theme_toggle_option_class
    assert_includes Keystone::Ui::ThemeToggleComponent::OPTION_CLASSES, "ks-theme-toggle-option"
  end

  def test_option_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ThemeToggleComponent::OPTION_CLASSES
  end

  def test_group_classes_render_the_ks_theme_toggle_class
    assert_includes Keystone::Ui::ThemeToggleComponent::GROUP_CLASSES, "ks-theme-toggle"
  end

  def test_group_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ThemeToggleComponent::GROUP_CLASSES
  end
end
