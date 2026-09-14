# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::SelectComponentTest < Minitest::Test
  def test_returns_base_classes
    component = Keystone::Ui::SelectComponent.new(name: "status")

    assert_equal "ks-input", component.classes
  end

  def test_appends_disabled_classes_when_disabled
    component = Keystone::Ui::SelectComponent.new(name: "status", disabled: true)

    assert_includes component.classes, "cursor-not-allowed"
  end

  def test_stores_name
    component = Keystone::Ui::SelectComponent.new(name: "event_name")

    assert_equal "event_name", component.tag_options[:name]
  end

  def test_includes_disabled_attribute_when_disabled
    component = Keystone::Ui::SelectComponent.new(name: "x", disabled: true)

    assert_equal true, component.tag_options[:disabled]
  end

  def test_stores_options_list
    opts = [ [ "Active", "active" ], [ "Inactive", "inactive" ] ]
    component = Keystone::Ui::SelectComponent.new(name: "status", options: opts)

    assert_equal opts, component.options
  end

  def test_stores_selected_value
    component = Keystone::Ui::SelectComponent.new(name: "status", selected: "active")

    assert_equal "active", component.selected
  end

  def test_stores_include_blank
    component = Keystone::Ui::SelectComponent.new(name: "status", include_blank: "All")

    assert_equal "All", component.include_blank
  end
end
