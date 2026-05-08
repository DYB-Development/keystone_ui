# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::SettingsLinkComponentTest < Minitest::Test
  def test_stores_label_and_href
    component = Keystone::Ui::SettingsLinkComponent.new(label: "Profile", href: "/profile")

    assert_equal "Profile", component.label
    assert_equal "/profile", component.href
  end

  def test_includes_flex_layout_and_padding_in_link_classes
    component = Keystone::Ui::SettingsLinkComponent.new(label: "Profile", href: "/profile")

    assert_includes component.link_classes, "flex"
    assert_includes component.link_classes, "items-center"
    assert_includes component.link_classes, "justify-between"
    assert_includes component.link_classes, "px-4"
    assert_includes component.link_classes, "py-3"
  end

  def test_includes_hover_and_dark_mode_classes
    component = Keystone::Ui::SettingsLinkComponent.new(label: "Profile", href: "/profile")

    assert_includes component.link_classes, "hover:bg-gray-50"
    assert_includes component.link_classes, "dark:hover:bg-gray-800"
  end

  def test_has_a_chevron_icon_svg
    assert_includes Keystone::Ui::SettingsLinkComponent::CHEVRON_ICON, "<svg"
    assert_includes Keystone::Ui::SettingsLinkComponent::CHEVRON_ICON, "</svg>"
  end
end
