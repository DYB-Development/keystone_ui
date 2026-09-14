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
end
