# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::MobileHeaderComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_exposes_title
    component = Keystone::Ui::MobileHeaderComponent.new(title: "Invoice #42", back_url: "/invoices")

    assert_equal "Invoice #42", component.instance_variable_get(:@title)
  end

  def test_exposes_back_url
    component = Keystone::Ui::MobileHeaderComponent.new(title: "Invoice #42", back_url: "/invoices")

    assert_equal "/invoices", component.instance_variable_get(:@back_url)
  end

  def test_stores_subtitle_when_provided
    component = Keystone::Ui::MobileHeaderComponent.new(title: "Invoice #42", back_url: "/invoices", subtitle: "Draft")

    assert_equal "Draft", component.instance_variable_get(:@subtitle)
  end

  def test_has_wrapper_classes_hidden_on_large_screens
    assert_includes Keystone::Ui::MobileHeaderComponent::WRAPPER_CLASSES, "lg:hidden"
  end

  def test_has_subtitle_classes_with_small_text_and_centering
    assert_includes Keystone::Ui::MobileHeaderComponent::SUBTITLE_CLASSES, "text-xs"
    assert_includes Keystone::Ui::MobileHeaderComponent::SUBTITLE_CLASSES, "text-center"
    assert_includes Keystone::Ui::MobileHeaderComponent::SUBTITLE_CLASSES, "truncate"
  end


  def test_has_title_classes_with_centered_positioning_and_truncation
    assert_includes Keystone::Ui::MobileHeaderComponent::TITLE_CLASSES, "absolute"
    assert_includes Keystone::Ui::MobileHeaderComponent::TITLE_CLASSES, "-translate-x-1/2"
    assert_includes Keystone::Ui::MobileHeaderComponent::TITLE_CLASSES, "truncate"
  end

  def test_hides_title_on_large_screens_with_lg_hidden
    assert_includes Keystone::Ui::MobileHeaderComponent::TITLE_CLASSES, "lg:hidden"
  end

  def test_has_dropdown_classes_with_hidden_and_positioning
    assert_includes Keystone::Ui::MobileHeaderComponent::DROPDOWN_CLASSES, "hidden"
    assert_includes Keystone::Ui::MobileHeaderComponent::DROPDOWN_CLASSES, "absolute"
    assert_includes Keystone::Ui::MobileHeaderComponent::DROPDOWN_CLASSES, "z-50"
  end

  def test_has_frozen_svg_icons
    assert Keystone::Ui::MobileHeaderComponent::BACK_ICON.frozen?
    assert_includes Keystone::Ui::MobileHeaderComponent::BACK_ICON, "<svg"
    assert Keystone::Ui::MobileHeaderComponent::ELLIPSIS_ICON.frozen?
    assert_includes Keystone::Ui::MobileHeaderComponent::ELLIPSIS_ICON, "<svg"
  end

  def test_back_link_classes_render_the_ks_mobile_header_back_class
    assert_includes Keystone::Ui::MobileHeaderComponent::BACK_LINK_CLASSES, "ks-mobile-header-back"
  end

  def test_back_link_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::MobileHeaderComponent::BACK_LINK_CLASSES
  end

  def test_title_classes_render_the_ks_mobile_header_title_class
    assert_includes Keystone::Ui::MobileHeaderComponent::TITLE_CLASSES, "ks-mobile-header-title"
  end

  def test_title_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::MobileHeaderComponent::TITLE_CLASSES
  end
end
