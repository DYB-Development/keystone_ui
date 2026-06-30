# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::FormFieldComponentTest < Minitest::Test
  def test_infers_label_text_from_attribute_name
    component = Keystone::Ui::FormFieldComponent.new(attribute: :first_name)

    assert_equal "First name", component.label_text
  end

  def test_uses_explicit_label_when_provided
    component = Keystone::Ui::FormFieldComponent.new(attribute: :name, label: "List Name")

    assert_equal "List Name", component.label_text
  end

  def test_exposes_required_flag
    assert_equal true, Keystone::Ui::FormFieldComponent.new(attribute: :name, required: true).required?
    assert_equal false, Keystone::Ui::FormFieldComponent.new(attribute: :name).required?
  end

  def test_exposes_hint_and_hint_text
    component = Keystone::Ui::FormFieldComponent.new(attribute: :name, hint: "Enter a descriptive name")

    assert_equal true, component.hint?
    assert_equal "Enter a descriptive name", component.hint_text
  end

  def test_returns_false_for_hint_when_no_hint
    component = Keystone::Ui::FormFieldComponent.new(attribute: :name)

    assert_equal false, component.hint?
  end

  def test_detects_textarea_type
    assert_equal true, Keystone::Ui::FormFieldComponent.new(attribute: :bio, type: :textarea).textarea?
    assert_equal false, Keystone::Ui::FormFieldComponent.new(attribute: :name, type: :text).textarea?
  end

  def test_builds_input_options_with_type_and_placeholder
    component = Keystone::Ui::FormFieldComponent.new(attribute: :email, type: :email, placeholder: "you@example.com")
    options = component.input_options

    assert_equal "email", options[:name]
    assert_equal "email", options[:type]
    assert_equal "you@example.com", options[:placeholder]
  end

  def test_includes_input_base_classes_in_input_options
    component = Keystone::Ui::FormFieldComponent.new(attribute: :name)

    assert_equal Keystone::Ui::InputComponent::BASE_CLASSES, component.input_options[:class]
  end

  def test_omits_type_from_input_options_for_textarea
    component = Keystone::Ui::FormFieldComponent.new(attribute: :bio, type: :textarea)

    refute component.input_options.key?(:type)
  end

  def test_includes_min_and_max_for_number_inputs
    component = Keystone::Ui::FormFieldComponent.new(attribute: :quantity, type: :number, min: 1, max: 100)
    options = component.input_options

    assert_equal 1, options[:min]
    assert_equal 100, options[:max]
  end

  def test_detects_checkbox_type
    component = Keystone::Ui::FormFieldComponent.new(attribute: :agree, type: :checkbox)

    assert_equal true, component.checkbox?
  end

  def test_detects_select_type
    component = Keystone::Ui::FormFieldComponent.new(attribute: :zone, type: :select, options: [ [ "Zone 1", "1" ] ])

    assert_equal true, component.select?
    assert_equal [ [ "Zone 1", "1" ] ], component.select_options
  end

  def test_maps_date_type_to_date_input
    component = Keystone::Ui::FormFieldComponent.new(attribute: :start_date, type: :date)
    options = component.input_options

    assert_equal "date", options[:type]
  end

  def test_includes_step_in_input_options_when_provided
    component = Keystone::Ui::FormFieldComponent.new(attribute: :price, type: :number, step: 0.01)
    options = component.input_options

    assert_equal 0.01, options[:step]
  end

  def test_includes_value_in_input_options_when_provided
    component = Keystone::Ui::FormFieldComponent.new(attribute: :price, type: :number, value: 9.99)
    options = component.input_options

    assert_equal 9.99, options[:value]
  end

  def test_stores_errors_when_provided
    component = Keystone::Ui::FormFieldComponent.new(attribute: :name, errors: [ "can't be blank" ])

    assert_equal true, component.errors?
    assert_equal [ "can't be blank" ], component.error_messages
  end
end
