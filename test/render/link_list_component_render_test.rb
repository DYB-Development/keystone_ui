# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::LinkListComponentRenderTest < ViewComponent::TestCase
  def test_links_each_row_to_its_address_by_its_label
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "Monthly report", href: "/reports/abc" } ]))

    assert_equal "/reports/abc", page.css("a.ks-value-list-row", text: "Monthly report").attr("href").value
  end

  def test_shows_a_row_subtitle_as_a_note_under_its_label
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "Monthly report", href: "/reports/abc", subtitle: "October 2026" } ]))

    assert_equal "October 2026", page.css("a .ks-value-list-note").text.strip
  end

  def test_shows_a_row_value_after_its_label
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "Report PDF", href: "/products/abc", value: "2 downloads left" } ]))

    assert_equal "2 downloads left", page.css("a .ks-value-list-value").text.strip
  end
end
