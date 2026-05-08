# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::NavbarComponentTest < Minitest::Test
  def test_includes_top_nav_and_sticky_classes_by_default
    component = Keystone::Ui::NavbarComponent.new

    assert_includes component.nav_classes, "top-nav"
    assert_includes component.nav_classes, "sticky"
    assert_includes component.nav_classes, "top-0"
    assert_includes component.nav_classes, "z-40"
  end

  def test_omits_sticky_classes_when_sticky_false
    component = Keystone::Ui::NavbarComponent.new(sticky: false)

    assert_includes component.nav_classes, "top-nav"
    refute_includes component.nav_classes, "sticky"
  end

  def test_has_mobile_left_classes_hidden_on_desktop
    assert_includes Keystone::Ui::NavbarComponent::MOBILE_LEFT_CLASSES, "lg:hidden"
    assert_includes Keystone::Ui::NavbarComponent::MOBILE_LEFT_CLASSES, "flex"
  end

  def test_has_desktop_links_classes_hidden_on_mobile
    assert_includes Keystone::Ui::NavbarComponent::DESKTOP_LINKS_CLASSES, "hidden"
    assert_includes Keystone::Ui::NavbarComponent::DESKTOP_LINKS_CLASSES, "lg:flex"
  end

  def test_has_mobile_center_classes_with_centered_positioning
    assert_includes Keystone::Ui::NavbarComponent::MOBILE_CENTER_CLASSES, "absolute"
    assert_includes Keystone::Ui::NavbarComponent::MOBILE_CENTER_CLASSES, "-translate-x-1/2"
    assert_includes Keystone::Ui::NavbarComponent::MOBILE_CENTER_CLASSES, "truncate"
  end
end
