# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::FileUploadComponentTest < Minitest::Test
  def test_requires_a_name
    component = Keystone::Ui::FileUploadComponent.new(name: "avatar")

    assert_equal "avatar", component.input_name
  end

  def test_defaults_to_single_file_upload
    component = Keystone::Ui::FileUploadComponent.new(name: "avatar")

    assert_equal false, component.multiple?
  end

  def test_supports_multiple_file_uploads
    component = Keystone::Ui::FileUploadComponent.new(name: "documents", multiple: true)

    assert_equal true, component.multiple?
  end

  def test_accepts_allowed_file_types
    component = Keystone::Ui::FileUploadComponent.new(name: "photo", accept: "image/*")

    assert_equal "image/*", component.accept
  end

  def test_returns_nil_accept_when_not_specified
    component = Keystone::Ui::FileUploadComponent.new(name: "file")

    assert_nil component.accept
  end

  def test_provides_a_default_label
    component = Keystone::Ui::FileUploadComponent.new(name: "document")

    assert_equal "Choose file", component.label_text
  end

  def test_accepts_a_custom_label
    component = Keystone::Ui::FileUploadComponent.new(name: "photo", label: "Upload photo")

    assert_equal "Upload photo", component.label_text
  end

  def test_exposes_hint_and_hint_text
    component = Keystone::Ui::FileUploadComponent.new(name: "avatar", hint: "Max 5MB")

    assert_equal true, component.hint?
    assert_equal "Max 5MB", component.hint_text
  end

  def test_returns_false_for_hint_when_no_hint
    component = Keystone::Ui::FileUploadComponent.new(name: "avatar")

    assert_equal false, component.hint?
  end

  def test_builds_tag_options_for_single_file_input
    component = Keystone::Ui::FileUploadComponent.new(name: "avatar", accept: "image/*")
    options = component.tag_options

    assert_equal "file", options[:type]
    assert_equal "avatar", options[:name]
    assert_equal "image/*", options[:accept]
    refute options.key?(:multiple)
  end

  def test_builds_tag_options_for_multiple_file_input
    component = Keystone::Ui::FileUploadComponent.new(name: "documents[]", multiple: true)
    options = component.tag_options

    assert_equal "documents[]", options[:name]
    assert_equal true, options[:multiple]
  end

  def test_omits_accept_from_tag_options_when_not_specified
    component = Keystone::Ui::FileUploadComponent.new(name: "file")

    refute component.tag_options.key?(:accept)
  end

  def test_wires_the_file_upload_stimulus_controller_on_the_wrapper
    component = Keystone::Ui::FileUploadComponent.new(name: "avatar")

    assert_equal({ controller: "file-upload" }, component.wrapper_data)
  end

  def test_marks_the_drop_zone_as_a_stimulus_target
    component = Keystone::Ui::FileUploadComponent.new(name: "avatar")

    assert_equal "dropZone", component.drop_zone_data[:"file-upload-target"]
  end

  def test_marks_the_input_as_a_stimulus_target_with_change_action
    component = Keystone::Ui::FileUploadComponent.new(name: "avatar")

    assert_equal "input", component.input_data[:"file-upload-target"]
    assert_equal "change->file-upload#select", component.input_data[:action]
  end

  def test_provides_accent_based_active_classes_for_drag_over_feedback
    assert_includes Keystone::Ui::FileUploadComponent::DROP_ZONE_ACTIVE_CLASSES, "border-accent-500"
    assert_includes Keystone::Ui::FileUploadComponent::DROP_ZONE_ACTIVE_CLASSES, "bg-accent-50"
  end

  def test_shows_drop_prompt_text_appropriate_for_single_vs_multiple
    single = Keystone::Ui::FileUploadComponent.new(name: "avatar")
    multi = Keystone::Ui::FileUploadComponent.new(name: "docs[]", multiple: true)

    assert_equal "Drop file here or", single.prompt_text
    assert_equal "Drop files here or", multi.prompt_text
  end
end
