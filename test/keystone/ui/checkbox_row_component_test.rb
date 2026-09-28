# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::CheckboxRowComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_exposes_name_value_and_label
    component = Keystone::Ui::CheckboxRowComponent.new(name: "shown[]", value: "merged", label: "Merged")

    assert_equal [ "shown[]", "merged", "Merged" ], [ component.name, component.value, component.label ]
  end

  def test_defaults_checked_to_false
    component = Keystone::Ui::CheckboxRowComponent.new(name: "shown[]", value: "merged", label: "Merged")

    assert_equal false, component.checked?
  end

  def test_exposes_hint
    component = Keystone::Ui::CheckboxRowComponent.new(name: "shown[]", value: "merged", label: "Merged", hint: "Pull requests merged in the range")

    assert_equal "Pull requests merged in the range", component.hint
  end

  def test_row_classes_render_the_ks_checkbox_row_class
    assert_includes Keystone::Ui::CheckboxRowComponent::ROW_CLASSES, "ks-checkbox-row"
  end

  def test_row_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::CheckboxRowComponent::ROW_CLASSES
  end

  def test_input_classes_render_the_ks_checkbox_row_input_class
    assert_includes Keystone::Ui::CheckboxRowComponent::INPUT_CLASSES, "ks-checkbox-row-input"
  end

  def test_input_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::CheckboxRowComponent::INPUT_CLASSES
  end
end
