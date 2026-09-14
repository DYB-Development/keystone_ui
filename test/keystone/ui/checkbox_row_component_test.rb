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
end
