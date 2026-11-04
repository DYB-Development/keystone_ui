# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::SortableListComponentRenderTest < ViewComponent::TestCase
  ROWS = [ { id: 7, label: "Ann" }, { id: 3, label: "Bo" }, { id: 9, label: "Cy" } ].freeze

  def test_the_list_is_named_for_screen_readers
    page = render_list(label: "Tied for 2nd")

    assert_equal "Tied for 2nd", page.at_css("ul")&.[]("aria-label")
  end

  private

  def render_list(name: "order[]", label: "Tied players", rows: ROWS)
    render_inline(Keystone::Ui::SortableListComponent.new(name: name, label: label, rows: rows))
  end
end
