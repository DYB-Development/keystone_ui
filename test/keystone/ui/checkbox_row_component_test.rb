# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::CheckboxRowComponentTest < Minitest::Test
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

  def test_row_classes_make_the_whole_row_clickable
    component = Keystone::Ui::CheckboxRowComponent.new(name: "shown[]", value: "merged", label: "Merged")

    assert_includes component.row_classes, "cursor-pointer"
  end

  def test_label_classes_stay_readable_in_dark_mode
    component = Keystone::Ui::CheckboxRowComponent.new(name: "shown[]", value: "merged", label: "Merged")

    assert_includes component.label_classes, "dark:text-surface-100"
  end

  def test_hint_classes_stay_readable_in_dark_mode
    component = Keystone::Ui::CheckboxRowComponent.new(name: "shown[]", value: "merged", label: "Merged", hint: "Pull requests merged in the range")

    assert_includes component.hint_classes, "dark:text-surface-400"
  end
end
