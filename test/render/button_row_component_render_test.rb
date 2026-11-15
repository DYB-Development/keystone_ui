# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ButtonRowComponentRenderTest < ViewComponent::TestCase
  BUTTONS = "<button class=\"ks-button\">Add label</button><button class=\"ks-button\">Re-run step</button>".html_safe

  def test_shows_its_buttons_in_one_row_with_even_gaps_between_them
    page = render_inline(Keystone::Ui::ButtonRowComponent.new) { BUTTONS }

    assert_equal [ "Add label", "Re-run step" ], page.css("div.flex.ks-grid-gap-sm > .ks-button").map(&:text)
  end

  def test_wraps_its_buttons_onto_a_new_line_when_it_runs_out_of_width
    page = render_inline(Keystone::Ui::ButtonRowComponent.new) { BUTTONS }

    assert_includes page.at_css("div")["class"].split, "flex-wrap"
  end
end
