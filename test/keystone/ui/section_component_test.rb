# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::SectionComponentTest < Minitest::Test
  def test_defaults_to_mt_6_spacing
    component = Keystone::Ui::SectionComponent.new

    assert_equal "mt-6", component.spacing_class
  end

  def test_maps_each_spacing_value_correctly
    assert_equal "mt-4", Keystone::Ui::SectionComponent.new(spacing: :sm).spacing_class
    assert_equal "mt-6", Keystone::Ui::SectionComponent.new(spacing: :md).spacing_class
    assert_equal "mt-8", Keystone::Ui::SectionComponent.new(spacing: :lg).spacing_class
  end

  def test_returns_true_for_header_when_title_is_present
    component = Keystone::Ui::SectionComponent.new(title: "Users")

    assert_equal true, component.header?
  end

  def test_returns_false_for_header_when_title_is_nil
    component = Keystone::Ui::SectionComponent.new

    assert_equal false, component.header?
  end

  def test_stores_the_action_hash
    action = { label: "View all", href: "/users" }
    component = Keystone::Ui::SectionComponent.new(title: "Users", action: action)

    assert_equal action, component.instance_variable_get(:@action)
  end

  def test_has_header_classes_with_flex_layout_and_spacing
    assert_includes Keystone::Ui::SectionComponent::HEADER_CLASSES, "flex"
    assert_includes Keystone::Ui::SectionComponent::HEADER_CLASSES, "justify-between"
    assert_includes Keystone::Ui::SectionComponent::HEADER_CLASSES, "mb-4"
  end

  def test_has_title_classes_with_semibold_text_styling
    assert_includes Keystone::Ui::SectionComponent::TITLE_CLASSES, "font-semibold"
    assert_includes Keystone::Ui::SectionComponent::TITLE_CLASSES, "text-lg"
  end

  def test_uses_semantic_accent_classes_for_action_link
    component = Keystone::Ui::SectionComponent.new(title: "Users")

    assert_includes component.action_classes, "text-accent-600"
    assert_includes component.action_classes, "hover:text-accent-900"
    assert_includes component.action_classes, "dark:text-accent-400"
    assert_includes component.action_classes, "dark:hover:text-accent-300"
  end
end
