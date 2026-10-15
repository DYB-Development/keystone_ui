# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ValueListComponentRenderTest < ViewComponent::TestCase
  def test_shows_each_row_with_its_label_and_value
    page = render_inline(Keystone::Ui::ValueListComponent.new(rows: [ { label: "Rate", value: "$150.00" }, { label: "Billable hours", value: "12.5" } ]))

    assert_equal [ [ "Rate", "$150.00" ], [ "Billable hours", "12.5" ] ],
      page.css(".ks-value-list-row").map { |row| [ row.css(".ks-value-list-label").text.strip, row.css(".ks-value-list-value").text.strip ] }
  end
end
