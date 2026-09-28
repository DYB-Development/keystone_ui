# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::SettingsLinkComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

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
  end


  def test_has_a_chevron_icon_svg
    assert_includes Keystone::Ui::SettingsLinkComponent::CHEVRON_ICON, "<svg"
    assert_includes Keystone::Ui::SettingsLinkComponent::CHEVRON_ICON, "</svg>"
  end

  def test_link_classes_render_the_ks_settings_link_class
    assert_includes Keystone::Ui::SettingsLinkComponent::LINK_CLASSES, "ks-settings-link"
  end

  def test_link_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::SettingsLinkComponent::LINK_CLASSES
  end

  def test_label_classes_render_the_ks_settings_link_label_class
    assert_includes Keystone::Ui::SettingsLinkComponent::LABEL_CLASSES, "ks-settings-link-label"
  end
end
