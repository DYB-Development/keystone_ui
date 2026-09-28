# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::WorkingComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

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

  def test_titles_a_group_in_keystones_label_style_with_no_visual_utility
    assert_includes Keystone::Ui::WorkingComponent::TITLE_CLASSES, "ks-label"
    refute_match VISUAL_UTILITY, Keystone::Ui::WorkingComponent::TITLE_CLASSES
  end

  def test_draws_the_working_lines_in_keystones_quiet_hint_style_with_no_visual_utility
    assert_includes Keystone::Ui::WorkingComponent::LINE_CLASSES, "ks-hint"
    refute_match VISUAL_UTILITY, Keystone::Ui::WorkingComponent::LINE_CLASSES
  end
end
