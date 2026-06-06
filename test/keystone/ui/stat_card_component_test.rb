# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::StatCardComponentTest < Minitest::Test
  def test_returns_card_classes
    component = Keystone::Ui::StatCardComponent.new(label: "Total", value: "42")

    assert_includes component.classes, "rounded-xl"
    assert_includes component.classes, "border"
    assert_includes component.classes, "p-6"
  end

  def test_exposes_label_and_value
    component = Keystone::Ui::StatCardComponent.new(label: "Published", value: "1,234")

    assert_equal "Published", component.label
    assert_equal "1,234", component.value
  end

  def test_defaults_to_neutral_variant
    component = Keystone::Ui::StatCardComponent.new(label: "Count", value: "0")

    assert_includes component.value_classes, "text-gray-900"
  end

  def test_maps_variant_to_value_color
    %i[neutral success danger warning info].each do |variant|
      component = Keystone::Ui::StatCardComponent.new(label: "X", value: "0", variant: variant)
      assert_includes component.value_classes, Keystone::Ui::StatCardComponent::VARIANT_CLASSES[variant]
    end
  end

  def test_exposes_label_classes
    component = Keystone::Ui::StatCardComponent.new(label: "X", value: "0")

    assert_includes component.label_classes, "text-sm"
  end

  def test_exposes_optional_suffix
    component = Keystone::Ui::StatCardComponent.new(label: "Latency", value: "42", suffix: "ms")

    assert_equal "ms", component.suffix
    assert_equal true, component.suffix?
  end

  def test_returns_false_for_suffix_when_not_provided
    component = Keystone::Ui::StatCardComponent.new(label: "Count", value: "5")

    assert_equal false, component.suffix?
  end

  def test_exposes_definition
    component = Keystone::Ui::StatCardComponent.new(label: "Marketing Conversion", value: "64%", definition: "qualified leads / total leads")

    assert_equal "qualified leads / total leads", component.definition
  end

  def test_exposes_calculation
    component = Keystone::Ui::StatCardComponent.new(label: "Marketing Conversion", value: "64%", calculation: "count(lead_qualified) / count(lead_created)")

    assert_equal "count(lead_qualified) / count(lead_created)", component.calculation
  end

  def test_info_is_false_when_neither_definition_nor_calculation_present
    component = Keystone::Ui::StatCardComponent.new(label: "Count", value: "5")

    assert_equal false, component.info?
  end

  def test_info_is_true_when_definition_present
    component = Keystone::Ui::StatCardComponent.new(label: "Count", value: "5", definition: "rows in table")

    assert_equal true, component.info?
  end

  def test_info_is_true_when_calculation_present
    component = Keystone::Ui::StatCardComponent.new(label: "Count", value: "5", calculation: "count(*)")

    assert_equal true, component.info?
  end

  def test_disclosure_is_hidden_by_default
    component = Keystone::Ui::StatCardComponent.new(label: "Count", value: "5", definition: "rows")

    assert_includes component.disclosure_classes, "hidden"
  end

  def test_exposes_info_button_classes
    component = Keystone::Ui::StatCardComponent.new(label: "Count", value: "5", definition: "rows")

    assert_includes component.info_button_classes, "text-gray-400"
  end

  def test_info_icon_renders_svg
    component = Keystone::Ui::StatCardComponent.new(label: "Count", value: "5", definition: "rows")

    assert_includes component.info_icon, "<svg"
  end

  def test_exposes_change
    component = Keystone::Ui::StatCardComponent.new(label: "Revenue", value: "$1k", change: 12.3)

    assert_in_delta 12.3, component.change
  end

  def test_change_is_false_when_absent
    component = Keystone::Ui::StatCardComponent.new(label: "Revenue", value: "$1k")

    assert_equal false, component.change?
  end

  def test_change_is_true_when_present
    component = Keystone::Ui::StatCardComponent.new(label: "Revenue", value: "$1k", change: -4.0)

    assert_equal true, component.change?
  end
end
