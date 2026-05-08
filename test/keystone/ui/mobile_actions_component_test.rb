# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::MobileActionsComponentTest < Minitest::Test
  def test_has_wrapper_classes_with_relative_positioning_and_lg_hidden
    assert_includes Keystone::Ui::MobileActionsComponent::WRAPPER_CLASSES, "relative"
    assert_includes Keystone::Ui::MobileActionsComponent::WRAPPER_CLASSES, "lg:hidden"
  end

  def test_has_button_classes_with_gray_text_styling
    assert_includes Keystone::Ui::MobileActionsComponent::BUTTON_CLASSES, "text-gray-500"
  end

  def test_has_dropdown_classes_with_hidden_and_positioning
    assert_includes Keystone::Ui::MobileActionsComponent::DROPDOWN_CLASSES, "hidden"
    assert_includes Keystone::Ui::MobileActionsComponent::DROPDOWN_CLASSES, "absolute"
    assert_includes Keystone::Ui::MobileActionsComponent::DROPDOWN_CLASSES, "z-50"
  end

  def test_has_dropdown_classes_with_rounded_and_shadow_styling
    assert_includes Keystone::Ui::MobileActionsComponent::DROPDOWN_CLASSES, "rounded-md"
    assert_includes Keystone::Ui::MobileActionsComponent::DROPDOWN_CLASSES, "shadow-lg"
  end

  def test_has_a_frozen_ellipsis_icon_svg
    assert Keystone::Ui::MobileActionsComponent::ELLIPSIS_ICON.frozen?
    assert_includes Keystone::Ui::MobileActionsComponent::ELLIPSIS_ICON, "<svg"
  end

  def test_provides_dropdown_stimulus_controller_data
    component = Keystone::Ui::MobileActionsComponent.new

    assert_equal "dropdown", component.wrapper_data[:controller]
  end
end
