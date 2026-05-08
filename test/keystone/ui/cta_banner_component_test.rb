# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::CtaBannerComponentTest < Minitest::Test
  def test_returns_card_classes
    component = Keystone::Ui::CtaBannerComponent.new(title: "Get Started")

    assert_includes component.classes, "rounded-2xl"
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

  def test_exposes_title_and_subtitle_classes
    component = Keystone::Ui::CtaBannerComponent.new(title: "X")

    assert_includes component.title_classes, "font-bold"
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
end
