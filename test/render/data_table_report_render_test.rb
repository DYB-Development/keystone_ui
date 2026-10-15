# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::DataTableReportRenderTest < ViewComponent::TestCase
  def test_aligns_a_column_given_end_alignment_right_in_its_heading_and_cells
    columns = [ Keystone::Ui::Column.new(:hours, "Hours", align: :end), Keystone::Ui::Column.new(:task, "Task") ]
    page = render_inline(Keystone::Ui::DataTableComponent.new(items: [ { hours: "2.5", task: "Export" } ], columns: columns))

    assert_equal [ true, true ], [ page.css("thead th").first[:class].split.include?("text-right"), page.css("tbody td").first[:class].split.include?("text-right") ]
  end

  def test_aligns_the_last_column_left_when_it_is_given_start_alignment
    columns = [ Keystone::Ui::Column.new(:task, "Task"), Keystone::Ui::Column.new(:notes, "Notes", align: :start) ]
    page = render_inline(Keystone::Ui::DataTableComponent.new(items: [ { task: "Export", notes: "Done" } ], columns: columns))

    assert_equal [ true, true ], [ page.css("thead th").last[:class].split.include?("text-left"), page.css("tbody td").last[:class].split.include?("text-left") ]
  end
end
