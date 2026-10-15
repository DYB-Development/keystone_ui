# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ValueListComponentRenderTest < ViewComponent::TestCase
  def test_shows_each_row_with_its_label_and_value
    page = render_inline(Keystone::Ui::ValueListComponent.new(rows: [ { label: "Rate", value: "$150.00" }, { label: "Billable hours", value: "12.5" } ]))

    assert_equal [ [ "Rate", "$150.00" ], [ "Billable hours", "12.5" ] ],
      page.css(".ks-value-list-row").map { |row| [ row.css(".ks-value-list-label").text.strip, row.css(".ks-value-list-value").text.strip ] }
  end

  def test_given_a_note_shows_it_under_the_row_label
    page = render_inline(Keystone::Ui::ValueListComponent.new(rows: [ { label: "Rate", value: "$150.00", note: "per hour" } ]))

    assert_equal "per hour", page.css(".ks-value-list-label .ks-value-list-note").text.strip
  end

  def test_draws_a_row_marked_as_the_total_as_a_total_row
    page = render_inline(Keystone::Ui::ValueListComponent.new(rows: [ { label: "Rate", value: "$150.00" }, { label: "Total billed", value: "$1,875.00", total: true } ]))

    assert_equal [ "Total billed" ], page.css(".ks-value-list-row.ks-value-list-total .ks-value-list-label").map { |label| label.text.strip }
  end

  def test_shows_a_rows_fallback_when_its_value_is_missing
    page = render_inline(Keystone::Ui::ValueListComponent.new(rows: [ { label: "Reviews", value: nil, fallback: "N/A" }, { label: "Deploys", value: "", fallback: "N/A" } ]))

    assert_equal [ "N/A", "N/A" ], page.css(".ks-value-list-value").map { |value| value.text.strip }
  end
end
