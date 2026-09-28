# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::FormComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_builds_form_options_with_url_and_default_post_method
    component = Keystone::Ui::FormComponent.new(action: "/items")
    options = component.form_options

    assert_equal "/items", options[:url]
    assert_equal :post, options[:method]
    assert_equal "ks-form", options[:class]
    assert_equal false, options[:multipart]
  end

  def test_passes_explicit_method_through_for_form_with
    component = Keystone::Ui::FormComponent.new(action: "/items/1", method: :patch)

    assert_equal :patch, component.form_options[:method]
  end

  def test_enables_multipart_when_requested
    component = Keystone::Ui::FormComponent.new(action: "/uploads", multipart: true)

    assert_equal true, component.form_options[:multipart]
  end

  def test_accepts_data_attributes
    component = Keystone::Ui::FormComponent.new(action: "/items", data: { turbo: true })

    assert_equal({ turbo: true }, component.form_options[:data])
  end

  def test_omits_data_key_when_not_provided
    component = Keystone::Ui::FormComponent.new(action: "/items")

    refute component.form_options.key?(:data)
  end

  def test_form_classes_render_the_ks_form_class
    assert_includes Keystone::Ui::FormComponent::FORM_CLASSES, "ks-form"
  end

  def test_form_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FormComponent::FORM_CLASSES
  end
end
