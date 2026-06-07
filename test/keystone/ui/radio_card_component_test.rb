# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::RadioCardComponentTest < Minitest::Test
  def test_exposes_label
    component = Keystone::Ui::RadioCardComponent.new(name: "need", value: "now", label: "Right now")

    assert_equal "Right now", component.label
  end

  def test_exposes_name_and_value
    component = Keystone::Ui::RadioCardComponent.new(name: "need", value: "now", label: "Right now")

    assert_equal "need", component.name
    assert_equal "now", component.value
  end
end
