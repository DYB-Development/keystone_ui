# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::BadgeComponentTest < Minitest::Test
  def test_returns_base_classes
    component = Keystone::Ui::BadgeComponent.new(label: "Active")

    assert_includes component.classes, "rounded-full"
    assert_includes component.classes, "text-xs"
    assert_includes component.classes, "font-medium"
  end

  def test_exposes_label
    component = Keystone::Ui::BadgeComponent.new(label: "Published")

    assert_equal "Published", component.label
  end

  def test_defaults_to_neutral_variant
    component = Keystone::Ui::BadgeComponent.new(label: "X")

    assert_includes component.classes, Keystone::Ui::BadgeComponent::VARIANT_CLASSES[:neutral]
  end

  def test_maps_each_variant_to_its_classes
    %i[neutral success danger warning info].each do |variant|
      component = Keystone::Ui::BadgeComponent.new(label: "X", variant: variant)
      assert_includes component.classes, Keystone::Ui::BadgeComponent::VARIANT_CLASSES[variant]
    end
  end
end
