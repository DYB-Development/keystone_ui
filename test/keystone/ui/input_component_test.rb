# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::InputComponentTest < Minitest::Test
  def test_returns_base_classes_for_a_default_text_input
    component = Keystone::Ui::InputComponent.new(name: "search")

    assert_equal "ks-input", component.classes
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

    assert_equal "ks-input ks-input-disabled", component.classes
    assert_equal true, component.tag_options[:disabled]
  end
end
