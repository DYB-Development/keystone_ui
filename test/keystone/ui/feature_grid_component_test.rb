# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::FeatureGridComponentTest < Minitest::Test
  def features
    @features ||= [
      { icon: "X", title: "Fast", description: "Very fast." },
      { icon: "Y", title: "Safe", description: "Very safe." }
    ]
  end

  def test_returns_wrapper_classes
    component = Keystone::Ui::FeatureGridComponent.new(title: "Features", features: features)

    assert_includes component.classes, "grid"
    assert_includes component.classes, "gap-6"
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
end
