# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::NavDropdownComponentTest < Minitest::Test
  def test_stores_title
    component = Keystone::Ui::NavDropdownComponent.new(title: "Plan", area: :plan, active: false)

    assert_equal "Plan", component.title
  end

  def test_includes_active_class_on_trigger_when_active
    component = Keystone::Ui::NavDropdownComponent.new(title: "Plan", area: :plan, active: true)

    assert_includes component.trigger_classes, "active"
  end

  def test_excludes_active_class_on_trigger_when_not_active
    component = Keystone::Ui::NavDropdownComponent.new(title: "Plan", area: :plan, active: false)

    refute_includes component.trigger_classes, "active"
  end

  def test_includes_trigger_base_class_when_not_active
    component = Keystone::Ui::NavDropdownComponent.new(title: "Plan", area: :plan, active: false)

    assert_equal "nav-dropdown-trigger", component.trigger_classes
  end

  def test_exposes_area
    component = Keystone::Ui::NavDropdownComponent.new(title: "Plan", area: :plan, active: false)

    assert_equal :plan, component.area
  end

  def test_has_wrapper_classes_with_nav_dropdown
    assert_equal "nav-dropdown", Keystone::Ui::NavDropdownComponent::WRAPPER_CLASSES
  end

  def test_has_menu_classes_with_hidden
    assert_includes Keystone::Ui::NavDropdownComponent::MENU_CLASSES, "hidden"
    assert_includes Keystone::Ui::NavDropdownComponent::MENU_CLASSES, "nav-dropdown-menu"
  end

  def test_has_a_frozen_caret_icon_svg
    assert Keystone::Ui::NavDropdownComponent::CARET_ICON.frozen?
    assert_includes Keystone::Ui::NavDropdownComponent::CARET_ICON, "<svg"
  end

  def test_wires_the_dropdown_stimulus_controller
    component = Keystone::Ui::NavDropdownComponent.new(title: "Plan", area: :plan, active: false)

    assert_equal "dropdown", component.wrapper_data[:controller]
  end
end
