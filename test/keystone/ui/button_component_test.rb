# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::ButtonComponentTest < Minitest::Test
  def test_combines_base_variant_and_size_classes
    component = Keystone::Ui::ButtonComponent.new(label: "Create invoice", variant: :secondary, size: :lg)

    assert_equal "ks-button ks-button-secondary ks-button-lg", component.classes
  end

  def test_defaults_to_submit_type_when_rendering_a_button_element
    component = Keystone::Ui::ButtonComponent.new(label: "Create invoice")

    assert_equal "submit", component.tag_options[:type]
  end

  def test_allows_overriding_the_button_type
    component = Keystone::Ui::ButtonComponent.new(label: "Cancel", type: :button)

    assert_equal "button", component.tag_options[:type]
  end

  def test_renders_the_primary_variant_by_default
    component = Keystone::Ui::ButtonComponent.new(label: "Save")

    assert_equal "ks-button ks-button-primary ks-button-md", component.classes
  end

  def test_passes_data_attributes_through_to_tag_options
    component = Keystone::Ui::ButtonComponent.new(label: "Delete", data: { action: "click->bulk-select#showConfirm", bulk_select_target: "removeButton" })

    assert_equal({ action: "click->bulk-select#showConfirm", bulk_select_target: "removeButton" }, component.tag_options[:data])
  end

  def test_renders_as_a_link_with_href_when_href_is_provided
    component = Keystone::Ui::ButtonComponent.new(label: "Visit", href: "/products")

    assert_equal :a, component.tag_name
    assert_equal "/products", component.tag_options[:href]
    refute component.tag_options.key?(:type)
  end
end
