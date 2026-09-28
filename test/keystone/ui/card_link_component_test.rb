# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::CardLinkComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_includes_block_border_bg_padding_shadow_radius_and_hover_by_default
    component = Keystone::Ui::CardLinkComponent.new(href: "/test")

    classes = component.classes
    assert_includes classes, "block"
    assert_includes classes, "border"
    assert_includes classes, "shadow-sm"
    assert_includes classes, "hover:border-accent-500/50"
  end

  def test_stores_the_href
    component = Keystone::Ui::CardLinkComponent.new(href: "/people/1")

    assert_equal "/people/1", component.href
  end


  def test_omits_shadow_sm_when_shadow_false
    component = Keystone::Ui::CardLinkComponent.new(href: "/", shadow: false)

    refute_includes component.classes, "shadow-sm"
  end

  def test_always_includes_dark_mode_and_hover_classes
    component = Keystone::Ui::CardLinkComponent.new(href: "/")

    assert_includes component.classes, "hover:border-accent-500/50"
  end

  def test_base_classes_render_the_ks_link_card_class
    assert_includes Keystone::Ui::CardLinkComponent::BASE_CLASSES, "ks-link-card"
  end

  def test_base_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::CardLinkComponent::BASE_CLASSES
  end

  def test_padding_classes_map_to_look_classes
    assert_equal({ sm: "ks-link-card-padding-sm", md: "ks-link-card-padding-md", lg: "ks-link-card-padding-lg" }, Keystone::Ui::CardLinkComponent::PADDING_CLASSES)
  end
end
