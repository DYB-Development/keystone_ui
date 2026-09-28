# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::CopyButtonComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_returns_button_classes
    component = Keystone::Ui::CopyButtonComponent.new(text: "hello")

    assert_includes component.classes, "text-sm"
  end

  def test_stores_text_to_copy
    component = Keystone::Ui::CopyButtonComponent.new(text: "some-value")

    assert_equal "some-value", component.text
  end

  def test_defaults_label_to_copy
    component = Keystone::Ui::CopyButtonComponent.new(text: "x")

    assert_equal "Copy", component.label
  end

  def test_accepts_custom_label
    component = Keystone::Ui::CopyButtonComponent.new(text: "x", label: "Copy Token")

    assert_equal "Copy Token", component.label
  end

  def test_exposes_success_and_error_messages
    component = Keystone::Ui::CopyButtonComponent.new(text: "x", success_message: "Done!", error_message: "Oops!")

    assert_equal "Done!", component.success_message
    assert_equal "Oops!", component.error_message
  end

  def test_defaults_success_and_error_messages
    component = Keystone::Ui::CopyButtonComponent.new(text: "x")

    assert_equal "Copied!", component.success_message
    assert_equal "Failed!", component.error_message
  end

  def test_provides_clipboard_stimulus_controller_data
    component = Keystone::Ui::CopyButtonComponent.new(text: "abc123")

    assert_equal "clipboard", component.wrapper_data[:controller]
    assert_equal "abc123", component.wrapper_data[:"clipboard-text"]
  end

  def test_button_classes_render_the_ks_copy_button_class
    assert_includes Keystone::Ui::CopyButtonComponent::BUTTON_CLASSES, "ks-copy-button"
  end

  def test_button_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::CopyButtonComponent::BUTTON_CLASSES
  end
end
