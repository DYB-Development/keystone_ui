# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::MultiSelectComponentTest < Minitest::Test
  def test_returns_display_text_as_all_label_when_nothing_selected
    component = Keystone::Ui::MultiSelectComponent.new(name: "cat[]", label: "Categories", options: [ [ "Shoes", 1 ] ])

    assert_equal "All Categories", component.display_text
  end

  def test_returns_count_when_items_are_selected
    component = Keystone::Ui::MultiSelectComponent.new(name: "cat[]", label: "Categories", options: [ [ "Shoes", 1 ], [ "Hats", 2 ] ], selected: [ "1", "2" ])

    assert_equal "2 selected", component.display_text
  end

  def test_reports_whether_a_value_is_selected
    component = Keystone::Ui::MultiSelectComponent.new(name: "cat[]", label: "Categories", options: [ [ "Shoes", 1 ], [ "Hats", 2 ] ], selected: [ 1 ])

    assert_equal true, component.selected?(1)
    assert_equal false, component.selected?(2)
  end
end
