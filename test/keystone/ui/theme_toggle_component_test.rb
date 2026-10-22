# frozen_string_literal: true

require "test_helper"
require_relative "../../../lib/keystone_ui/theme_choice"

class Keystone::Ui::ThemeToggleComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_button_classes_render_the_ks_theme_toggle_class
    assert_includes Keystone::Ui::ThemeToggleComponent::BUTTON_CLASSES, "ks-theme-toggle"
  end

  def test_button_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ThemeToggleComponent::BUTTON_CLASSES
  end
end
