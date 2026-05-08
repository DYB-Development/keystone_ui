# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::ButtonComponentTest < Minitest::Test
  def test_combines_base_variant_and_size_classes
    component = Keystone::Ui::ButtonComponent.new(label: "Create invoice", variant: :secondary, size: :lg)

    assert_equal "inline-flex items-center justify-center font-semibold rounded-lg border-0 cursor-pointer no-underline bg-gray-500 text-white hover:bg-gray-400 text-lg px-5 py-3", component.classes
  end

  def test_defaults_to_submit_type_when_rendering_a_button_element
    component = Keystone::Ui::ButtonComponent.new(label: "Create invoice")

    assert_equal "submit", component.tag_options[:type]
  end

  def test_allows_overriding_the_button_type
    component = Keystone::Ui::ButtonComponent.new(label: "Cancel", type: :button)

    assert_equal "button", component.tag_options[:type]
  end

  def test_uses_semantic_accent_classes_for_primary_variant
    component = Keystone::Ui::ButtonComponent.new(label: "Save")

    assert_includes component.classes, "bg-accent-600"
    assert_includes component.classes, "hover:bg-accent-500"
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
