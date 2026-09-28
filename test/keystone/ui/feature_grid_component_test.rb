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

  def test_exposes_card_classes
    component = Keystone::Ui::FeatureGridComponent.new(title: "X", features: features)

    assert_includes component.card_classes, "rounded-xl"
    assert_includes component.card_classes, "border"
    assert_includes component.card_classes, "p-6"
  end

  def test_exposes_icon_wrapper_classes
    component = Keystone::Ui::FeatureGridComponent.new(title: "X", features: features)

    assert_includes component.icon_classes, "rounded-lg"
  end

  def test_uses_semantic_accent_classes
    component = Keystone::Ui::FeatureGridComponent.new(title: "X", features: features)

    assert_includes component.card_classes, "hover:border-accent-500/50"
    assert_includes component.icon_classes, "bg-accent-500/10"
    assert_includes component.icon_classes, "text-accent-600"
  end

  def test_uses_semantic_surface_classes
    component = Keystone::Ui::FeatureGridComponent.new(title: "X", subtitle: "Sub", features: features)

    assert_includes component.card_classes, "border-surface-200"
    assert_includes component.card_classes, "dark:border-surface-700"
    assert_includes component.title_classes, "text-surface-900"
    assert_includes component.subtitle_classes, "text-surface-500"
    assert_includes component.card_description_classes, "text-surface-500"
  end

  def test_grid_classes_render_the_ks_feature_grid_class
    assert_includes Keystone::Ui::FeatureGridComponent::GRID_CLASSES, "ks-feature-grid"
  end

  def test_grid_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FeatureGridComponent::GRID_CLASSES
  end
end
