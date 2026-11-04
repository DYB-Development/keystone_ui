# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::SortableListComponentRenderTest < ViewComponent::TestCase
  ROWS = [ { id: 7, label: "Ann" }, { id: 3, label: "Bo" }, { id: 9, label: "Cy" } ].freeze

  def test_the_list_is_named_for_screen_readers
    page = render_list(label: "Tied for 2nd")

    assert_equal "Tied for 2nd", page.at_css("ul")&.[]("aria-label")
  end

  def test_each_row_shows_its_label_in_the_given_order
    page = render_list

    assert_equal [ "Ann", "Bo", "Cy" ], page.css("li").map { |row| row.text.strip }
  end

  private

  def render_list(name: "order[]", label: "Tied players", rows: ROWS)
    render_inline(Keystone::Ui::SortableListComponent.new(name: name, label: label, rows: rows))
  end
end
