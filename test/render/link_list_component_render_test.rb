# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::LinkListComponentRenderTest < ViewComponent::TestCase
  def test_links_each_row_to_its_address_by_its_label
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "Monthly report", href: "/reports/abc" } ]))

    assert_equal "/reports/abc", page.css("a.ks-value-list-row", text: "Monthly report").attr("href").value
  end
end
