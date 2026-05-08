# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::TextareaComponentTest < Minitest::Test
  def test_returns_base_classes
    component = Keystone::Ui::TextareaComponent.new(name: "notes")

    assert_includes component.classes, "block w-full rounded-md border"
  end

  def test_defaults_rows_to_3
    component = Keystone::Ui::TextareaComponent.new(name: "notes")

    assert_equal 3, component.tag_options[:rows]
  end

  def test_builds_tag_options_with_name_rows_and_placeholder
    component = Keystone::Ui::TextareaComponent.new(name: "bio", rows: 5, placeholder: "Tell us about yourself")
    options = component.tag_options

    assert_equal "bio", options[:name]
    assert_equal 5, options[:rows]
    assert_equal "Tell us about yourself", options[:placeholder]
  end

  def test_adds_disabled_classes_and_attribute_when_disabled
    component = Keystone::Ui::TextareaComponent.new(name: "locked", disabled: true)

    assert_includes component.classes, Keystone::Ui::TextareaComponent::DISABLED_CLASSES
    assert_equal true, component.tag_options[:disabled]
  end

  def test_uses_semantic_accent_classes_for_focus_state
    component = Keystone::Ui::TextareaComponent.new(name: "notes")

    assert_includes component.classes, "focus:border-accent-500"
    assert_includes component.classes, "focus:ring-accent-500"
  end
end
