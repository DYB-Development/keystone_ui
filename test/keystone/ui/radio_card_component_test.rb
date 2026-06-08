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

  def test_defaults_checked_to_false
    component = Keystone::Ui::RadioCardComponent.new(name: "need", value: "now", label: "Right now")

    assert_equal false, component.checked?
  end

  def test_reflects_checked_when_set
    component = Keystone::Ui::RadioCardComponent.new(name: "need", value: "now", label: "Right now", checked: true)

    assert_equal true, component.checked?
  end

  def test_exposes_hint
    component = Keystone::Ui::RadioCardComponent.new(name: "need", value: "now", label: "Right now", hint: "current jobs")

    assert_equal "current jobs", component.hint
  end

  def test_has_no_hint_by_default
    component = Keystone::Ui::RadioCardComponent.new(name: "need", value: "now", label: "Right now")

    assert_equal false, component.hint?
  end
end
