# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::WorkingComponentTest < Minitest::Test
  def test_offers_the_working_under_a_quiet_summary_by_default
    assert_equal "How this is worked out", Keystone::Ui::WorkingComponent.new(groups: []).summary
  end

  def test_holds_each_line_of_a_group_as_its_label_working_and_result
    component = Keystone::Ui::WorkingComponent.new(groups: [
      { title: "Store runs", lines: [ { label: "Money a year", working: "$34.00 × 1,825", result: "$62,050.00" } ] }
    ])

    line = component.groups.first.lines.first

    assert_equal [ "Money a year", "$34.00 × 1,825", "$62,050.00" ], [ line.label, line.working, line.result ]
  end
end
