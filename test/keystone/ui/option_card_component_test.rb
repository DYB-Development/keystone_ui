# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::OptionCardComponentTest < Minitest::Test
  def test_exposes_base_classes_with_border
    component = Keystone::Ui::OptionCardComponent.new(name: "theme", value: "forest")

    assert_includes component.classes, "border-2"
    assert_includes component.classes, "rounded-lg"
    assert_includes component.classes, "cursor-pointer"
  end

  def test_uses_transparent_border_when_not_selected
    component = Keystone::Ui::OptionCardComponent.new(name: "theme", value: "forest", selected: false)

    assert_includes component.classes, "border-transparent"
    refute_includes component.classes, "border-accent-500"
  end

  def test_uses_accent_border_when_selected
    component = Keystone::Ui::OptionCardComponent.new(name: "theme", value: "forest", selected: true)

    assert_includes component.classes, "border-accent-500"
    refute_includes component.classes, "border-transparent"
  end

  def test_exposes_name_value_and_selected
    component = Keystone::Ui::OptionCardComponent.new(name: "color", value: "blue", selected: true)

    assert_equal "color", component.name
    assert_equal "blue", component.value
    assert_equal true, component.selected?
  end

  def test_defaults_selected_to_false
    component = Keystone::Ui::OptionCardComponent.new(name: "color", value: "blue")

    assert_equal false, component.selected?
  end
end
