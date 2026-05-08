# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::HeroComponentTest < Minitest::Test
  def test_exposes_title
    component = Keystone::Ui::HeroComponent.new(title: "Welcome")

    assert_equal "Welcome", component.title
  end

  def test_exposes_subtitle_when_provided
    component = Keystone::Ui::HeroComponent.new(title: "X", subtitle: "Subtext here.")

    assert_equal true, component.subtitle?
    assert_equal "Subtext here.", component.subtitle
  end

  def test_returns_false_for_subtitle_when_not_provided
    component = Keystone::Ui::HeroComponent.new(title: "X")

    assert_equal false, component.subtitle?
  end

  def test_exposes_badge_when_provided
    component = Keystone::Ui::HeroComponent.new(title: "X", badge: "New")

    assert_equal true, component.badge?
    assert_equal "New", component.badge
  end

  def test_returns_false_for_badge_when_not_provided
    component = Keystone::Ui::HeroComponent.new(title: "X")

    assert_equal false, component.badge?
  end

  def test_exposes_wrapper_classes
    component = Keystone::Ui::HeroComponent.new(title: "X")

    assert_includes component.classes, "min-h-screen"
  end

  def test_exposes_title_classes
    component = Keystone::Ui::HeroComponent.new(title: "X")

    assert_includes component.title_classes, "font-bold"
    assert_includes component.title_classes, "tracking-tight"
  end

  def test_supports_centered_layout
    component = Keystone::Ui::HeroComponent.new(title: "X", layout: :centered)

    assert_includes component.content_classes, "text-center"
  end

  def test_defaults_to_split_layout
    component = Keystone::Ui::HeroComponent.new(title: "X")

    assert_includes component.content_classes, "lg:grid-cols-2"
  end

  def test_registers_an_aside_slot
    assert Keystone::Ui::HeroComponent.registered_slots.key?(:aside)
  end

  def test_uses_semantic_accent_classes_for_badge
    component = Keystone::Ui::HeroComponent.new(title: "X", badge: "New")

    assert_includes component.badge_classes, "border-accent-500/20"
    assert_includes component.badge_classes, "text-accent-600"
    assert_includes component.badge_classes, "bg-accent-500/10"
    assert_includes component.badge_classes, "dark:text-accent-400"
  end

  def test_uses_semantic_surface_classes_for_title_and_subtitle
    component = Keystone::Ui::HeroComponent.new(title: "X", subtitle: "Sub")

    assert_includes component.title_classes, "text-surface-900"
    assert_includes component.subtitle_classes, "text-surface-500"
    assert_includes component.subtitle_classes, "dark:text-surface-400"
  end
end
