# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::MobileActionsComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_has_wrapper_classes_with_relative_positioning_and_lg_hidden
    assert_includes Keystone::Ui::MobileActionsComponent::WRAPPER_CLASSES, "relative"
    assert_includes Keystone::Ui::MobileActionsComponent::WRAPPER_CLASSES, "lg:hidden"
  end

  def test_has_dropdown_classes_with_hidden_and_positioning
    assert_includes Keystone::Ui::MobileActionsComponent::DROPDOWN_CLASSES, "hidden"
    assert_includes Keystone::Ui::MobileActionsComponent::DROPDOWN_CLASSES, "absolute"
    assert_includes Keystone::Ui::MobileActionsComponent::DROPDOWN_CLASSES, "z-50"
  end

  def test_has_a_frozen_ellipsis_icon_svg
    assert Keystone::Ui::MobileActionsComponent::ELLIPSIS_ICON.frozen?
    assert_includes Keystone::Ui::MobileActionsComponent::ELLIPSIS_ICON, "<svg"
  end

  def test_provides_dropdown_stimulus_controller_data
    component = Keystone::Ui::MobileActionsComponent.new

    assert_equal "dropdown", component.wrapper_data[:controller]
  end

  def test_button_classes_render_the_ks_action_menu_button_class
    assert_includes Keystone::Ui::MobileActionsComponent::BUTTON_CLASSES, "ks-action-menu-button"
  end

  def test_button_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::MobileActionsComponent::BUTTON_CLASSES
  end

  def test_dropdown_classes_render_the_ks_action_menu_class
    assert_includes Keystone::Ui::MobileActionsComponent::DROPDOWN_CLASSES, "ks-action-menu"
  end

  def test_dropdown_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::MobileActionsComponent::DROPDOWN_CLASSES
  end
end
