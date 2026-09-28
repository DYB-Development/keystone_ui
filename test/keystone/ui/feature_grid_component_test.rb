# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::FeatureGridComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def features
    @features ||= [
      { icon: "X", title: "Fast", description: "Very fast." },
      { icon: "Y", title: "Safe", description: "Very safe." }
    ]
  end

  def test_returns_wrapper_classes
    component = Keystone::Ui::FeatureGridComponent.new(title: "Features", features: features)

    assert_includes component.classes, "grid"
  end

  def test_exposes_title_and_subtitle
    component = Keystone::Ui::FeatureGridComponent.new(title: "Features", subtitle: "The best.", features: features)

    assert_equal "Features", component.title
    assert_equal "The best.", component.subtitle
    assert_equal true, component.subtitle?
  end

  def test_returns_false_for_subtitle_when_not_provided
    component = Keystone::Ui::FeatureGridComponent.new(title: "X", features: features)

    assert_equal false, component.subtitle?
  end

  def test_stores_features
    component = Keystone::Ui::FeatureGridComponent.new(title: "X", features: features)

    assert_equal features, component.features
  end




  def test_uses_semantic_surface_classes
    component = Keystone::Ui::FeatureGridComponent.new(title: "X", subtitle: "Sub", features: features)

    assert_includes component.card_description_classes, "text-surface-500"
  end

  def test_grid_classes_render_the_ks_feature_grid_class
    assert_includes Keystone::Ui::FeatureGridComponent::GRID_CLASSES, "ks-feature-grid"
  end

  def test_grid_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FeatureGridComponent::GRID_CLASSES
  end

  def test_title_base_classes_render_the_ks_feature_grid_title_class
    assert_includes Keystone::Ui::FeatureGridComponent::TITLE_BASE_CLASSES, "ks-feature-grid-title"
  end

  def test_title_base_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FeatureGridComponent::TITLE_BASE_CLASSES
  end

  def test_subtitle_base_classes_render_the_ks_feature_grid_subtitle_class
    assert_includes Keystone::Ui::FeatureGridComponent::SUBTITLE_BASE_CLASSES, "ks-feature-grid-subtitle"
  end

  def test_subtitle_base_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FeatureGridComponent::SUBTITLE_BASE_CLASSES
  end

  def test_card_layout_classes_render_the_ks_feature_card_class
    assert_includes Keystone::Ui::FeatureGridComponent::CARD_LAYOUT_CLASSES, "ks-feature-card"
  end

  def test_card_layout_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FeatureGridComponent::CARD_LAYOUT_CLASSES
  end

  def test_icon_base_classes_render_the_ks_feature_card_icon_class
    assert_includes Keystone::Ui::FeatureGridComponent::ICON_BASE_CLASSES, "ks-feature-card-icon"
  end

  def test_icon_base_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FeatureGridComponent::ICON_BASE_CLASSES
  end

  def test_card_title_base_classes_render_the_ks_feature_card_title_class
    assert_includes Keystone::Ui::FeatureGridComponent::CARD_TITLE_BASE_CLASSES, "ks-feature-card-title"
  end

  def test_card_title_base_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FeatureGridComponent::CARD_TITLE_BASE_CLASSES
  end

  def test_card_description_base_classes_render_the_ks_feature_card_description_class
    assert_includes Keystone::Ui::FeatureGridComponent::CARD_DESCRIPTION_BASE_CLASSES, "ks-feature-card-description"
  end

  def test_title_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FeatureGridComponent.new(title: "Why", features: []).title_classes
  end

  def test_subtitle_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FeatureGridComponent.new(title: "Why", features: []).subtitle_classes
  end

  def test_card_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FeatureGridComponent.new(title: "Why", features: []).card_classes
  end

  def test_icon_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FeatureGridComponent.new(title: "Why", features: []).icon_classes
  end
end
