# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::CtaBannerComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_returns_card_classes
    component = Keystone::Ui::CtaBannerComponent.new(title: "Get Started")

    assert_includes component.classes, "border"
    assert_includes component.classes, "text-center"
  end

  def test_exposes_title
    component = Keystone::Ui::CtaBannerComponent.new(title: "Ready?")

    assert_equal "Ready?", component.title
  end

  def test_exposes_subtitle_when_provided
    component = Keystone::Ui::CtaBannerComponent.new(title: "X", subtitle: "Get started today.")

    assert_equal true, component.subtitle?
    assert_equal "Get started today.", component.subtitle
  end

  def test_returns_false_for_subtitle_when_not_provided
    component = Keystone::Ui::CtaBannerComponent.new(title: "X")

    assert_equal false, component.subtitle?
  end


  def test_exposes_actions_wrapper_classes
    component = Keystone::Ui::CtaBannerComponent.new(title: "X")

    assert_includes component.actions_classes, "flex"
    assert_includes component.actions_classes, "justify-center"
  end

  def test_uses_semantic_surface_classes
    component = Keystone::Ui::CtaBannerComponent.new(title: "X", subtitle: "Sub")

    assert_includes component.classes, "border-surface-200"
    assert_includes component.classes, "dark:border-surface-700"
    assert_includes component.classes, "bg-surface-50"
    assert_includes component.title_classes, "text-surface-900"
    assert_includes component.subtitle_classes, "text-surface-500"
  end

  def test_card_layout_classes_render_the_ks_cta_banner_class
    assert_includes Keystone::Ui::CtaBannerComponent::CARD_LAYOUT_CLASSES, "ks-cta-banner"
  end

  def test_card_layout_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::CtaBannerComponent::CARD_LAYOUT_CLASSES
  end

  def test_title_base_classes_render_the_ks_cta_banner_title_class
    assert_includes Keystone::Ui::CtaBannerComponent::TITLE_BASE_CLASSES, "ks-cta-banner-title"
  end

  def test_title_base_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::CtaBannerComponent::TITLE_BASE_CLASSES
  end

  def test_subtitle_base_classes_render_the_ks_cta_banner_subtitle_class
    assert_includes Keystone::Ui::CtaBannerComponent::SUBTITLE_BASE_CLASSES, "ks-cta-banner-subtitle"
  end

  def test_subtitle_base_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::CtaBannerComponent::SUBTITLE_BASE_CLASSES
  end
end
