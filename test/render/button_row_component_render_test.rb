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

  def test_gives_every_button_an_equal_share_of_its_width_when_asked
    page = render_inline(Keystone::Ui::ButtonRowComponent.new(equal_width: true)) { BUTTONS }

    assert_includes page.at_css("div")["class"].split, "*:flex-1"
  end

  def test_makes_each_button_at_least_44px_tall_on_a_phone
    page = render_inline(Keystone::Ui::ButtonRowComponent.new) { BUTTONS }

    assert_includes page.at_css("div")["class"].split, "max-sm:*:min-h-11"
  end

  def test_keeps_each_label_on_one_line_in_an_equal_width_row_so_it_wraps_only_when_the_labels_no_longer_fit
    page = render_inline(Keystone::Ui::ButtonRowComponent.new(equal_width: true)) { BUTTONS }

    assert_includes page.at_css("div")["class"].split, "*:whitespace-nowrap"
  end

  def test_stretches_a_button_that_sends_a_request_from_its_own_form_across_the_form
    page = render_inline(Keystone::Ui::ButtonRowComponent.new) { BUTTONS }

    assert_empty %w[[&>form]:flex [&>form>*]:flex-1] - page.at_css("div")["class"].split
  end
end
