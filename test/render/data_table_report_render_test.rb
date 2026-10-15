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

  def test_lists_rows_sharing_a_group_value_under_one_heading_row_named_by_it
    items = [ { project: "Portal", task: "Export" }, { project: "Portal", task: "Login" }, { project: "Reporting", task: "Charts" } ]
    page = render_inline(Keystone::Ui::DataTableComponent.new(items: items, columns: [ { task: "Task" } ], group_by: :project))

    assert_equal %w[Portal Export Login Reporting Charts], page.css("tbody tr").map { |row| row.text.strip }
  end

  def test_shows_a_groups_subtotals_under_their_columns_in_its_heading_row
    items = [ { project: "Portal", task: "Export", hours: "2.0" }, { project: "Portal", task: "Login", hours: "1.5" } ]
    page = render_inline(Keystone::Ui::DataTableComponent.new(items: items, columns: [ { task: "Task" }, { hours: "Hours" } ],
      group_by: :project, group_totals: { "Portal" => { hours: "3.5" } }))

    assert_equal [ "Portal", "3.5" ], page.css("tbody tr[data-table-group] th").map { |cell| cell.text.strip }
  end
end
