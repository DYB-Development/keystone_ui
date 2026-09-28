# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::ColorPickerComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_stores_name_and_default_value
    component = Keystone::Ui::ColorPickerComponent.new(name: "accent", value: "#3b82f6")

    assert_equal "accent", component.name
    assert_equal "#3b82f6", component.value
  end

  def test_defaults_value_to_000000
    component = Keystone::Ui::ColorPickerComponent.new(name: "accent")

    assert_equal "#000000", component.value
  end

  def test_uses_the_color_picker_stimulus_controller
    component = Keystone::Ui::ColorPickerComponent.new(name: "accent")

    assert_equal "color-picker", component.controller_name
  end

  def test_provides_swatch_classes_for_the_trigger
    component = Keystone::Ui::ColorPickerComponent.new(name: "accent")

    assert_includes component.swatch_classes, "cursor-pointer"
  end

  def test_provides_panel_classes_for_the_dropdown
    component = Keystone::Ui::ColorPickerComponent.new(name: "accent")

    assert_includes component.panel_classes, "absolute"
    assert_includes component.panel_classes, "hidden"
  end

  def test_accepts_an_optional_label
    component = Keystone::Ui::ColorPickerComponent.new(name: "accent", label: "Accent Color")

    assert_equal "Accent Color", component.label
  end

  def test_swatch_classes_render_the_ks_color_swatch_class
    assert_includes Keystone::Ui::ColorPickerComponent::SWATCH_CLASSES, "ks-color-swatch"
  end

  def test_swatch_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ColorPickerComponent::SWATCH_CLASSES
  end

  def test_panel_classes_render_the_ks_color_picker_panel_class
    assert_includes Keystone::Ui::ColorPickerComponent::PANEL_CLASSES, "ks-color-picker-panel"
  end

  def test_panel_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ColorPickerComponent::PANEL_CLASSES
  end
end
