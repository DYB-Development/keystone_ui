# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::InputComponentTest < Minitest::Test
  def test_returns_base_classes_for_a_default_text_input
    component = Keystone::Ui::InputComponent.new(name: "search")

    assert_includes component.classes, "block w-full rounded-md border"
  end

  def test_builds_tag_options_with_type_name_and_class
    component = Keystone::Ui::InputComponent.new(name: "email", type: :email, placeholder: "you@example.com")
    options = component.tag_options

    assert_equal "email", options[:type]
    assert_equal "email", options[:name]
    assert_equal "you@example.com", options[:placeholder]
    refute options.key?(:disabled)
  end

  def test_includes_number_attributes_when_type_is_number
    component = Keystone::Ui::InputComponent.new(name: "qty", type: :number, value: 1, min: 0, max: 100, step: 1)
    options = component.tag_options

    assert_equal "number", options[:type]
    assert_equal 1, options[:value]
    assert_equal 0, options[:min]
    assert_equal 100, options[:max]
    assert_equal 1, options[:step]
  end

  def test_adds_disabled_classes_and_attribute_when_disabled
    component = Keystone::Ui::InputComponent.new(name: "locked", disabled: true)

    assert_includes component.classes, Keystone::Ui::InputComponent::DISABLED_CLASSES
    assert_equal true, component.tag_options[:disabled]
  end

  def test_uses_semantic_accent_classes_for_focus_state
    component = Keystone::Ui::InputComponent.new(name: "search")

    assert_includes component.classes, "focus:border-accent-500"
    assert_includes component.classes, "focus:ring-accent-500"
    assert_includes component.classes, "dark:focus:border-accent-400"
    assert_includes component.classes, "dark:focus:ring-accent-400"
  end
end
