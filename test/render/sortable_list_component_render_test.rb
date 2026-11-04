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

  def test_each_row_submits_its_id_in_a_hidden_field_named_by_the_caller
    page = render_list(name: "order[2][]")

    assert_equal [ [ "order[2][]", "7" ], [ "order[2][]", "3" ], [ "order[2][]", "9" ] ],
      page.css("li input[type=hidden]").map { |field| [ field["name"], field["value"] ] }
  end

  def test_each_row_is_a_target_of_the_sortable_list_controller
    page = render_list

    assert_equal 3, page.css("[data-controller=sortable-list] li[data-sortable-list-target=row]").length
  end

  def test_each_row_offers_a_move_up_button_named_for_its_label
    page = render_list

    assert_equal [ "Move Ann up", "Move Bo up", "Move Cy up" ],
      page.css("li button[data-action='sortable-list#moveUp']").map { |button| button["aria-label"] }
  end

  def test_each_row_offers_a_move_down_button_named_for_its_label
    page = render_list

    assert_equal [ "Move Ann down", "Move Bo down", "Move Cy down" ],
      page.css("li button[data-action='sortable-list#moveDown']").map { |button| button["aria-label"] }
  end

  def test_pressing_a_move_button_does_not_submit_the_form
    page = render_list

    assert_equal [ "button" ], page.css("li button").map { |button| button["type"] }.uniq
  end

  def test_each_row_has_a_drag_handle_that_follows_the_pointer
    page = render_list

    assert_equal [ "pointerdown->sortable-list#grab pointermove->sortable-list#drag pointerup->sortable-list#drop pointercancel->sortable-list#drop" ],
      page.css("li span[data-action]").map { |handle| handle["data-action"] }.uniq
  end

  def test_a_finger_on_the_handle_drags_rather_than_scrolls
    page = render_list

    assert_includes page.at_css("li span[data-action]")["class"].to_s.split, "touch-none"
  end

  private

  def render_list(name: "order[]", label: "Tied players", rows: ROWS)
    render_inline(Keystone::Ui::SortableListComponent.new(name: name, label: label, rows: rows))
  end
end
