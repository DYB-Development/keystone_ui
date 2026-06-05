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
end
