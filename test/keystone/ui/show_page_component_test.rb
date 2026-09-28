# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::ShowPageComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_returns_true_for_subtitle_when_subtitle_is_provided
    component = Keystone::Ui::ShowPageComponent.new(title: "Invoice #42", back_url: "/invoices", subtitle: "Paid")

    assert_equal true, component.subtitle?
  end

  def test_returns_false_for_subtitle_when_subtitle_is_not_provided
    component = Keystone::Ui::ShowPageComponent.new(title: "Invoice #42", back_url: "/invoices")

    assert_equal false, component.subtitle?
  end

  def test_has_desktop_wrapper_classes_hidden_on_mobile
    assert_includes Keystone::Ui::ShowPageComponent::DESKTOP_WRAPPER_CLASSES, "hidden"
    assert_includes Keystone::Ui::ShowPageComponent::DESKTOP_WRAPPER_CLASSES, "md:block"
  end

  def test_has_title_classes_constant
    assert_includes Keystone::Ui::ShowPageComponent::TITLE_CLASSES, "text-2xl"
  end

  def test_has_subtitle_classes_constant
    assert_includes Keystone::Ui::ShowPageComponent::SUBTITLE_CLASSES, "text-sm"
  end

  def test_title_classes_render_the_ks_page_title_class
    assert_includes Keystone::Ui::ShowPageComponent::TITLE_CLASSES, "ks-page-title"
  end

  def test_title_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ShowPageComponent::TITLE_CLASSES
  end

  def test_subtitle_classes_render_the_ks_page_header_subtitle_class
    assert_includes Keystone::Ui::ShowPageComponent::SUBTITLE_CLASSES, "ks-page-header-subtitle"
  end

  def test_subtitle_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ShowPageComponent::SUBTITLE_CLASSES
  end
end
