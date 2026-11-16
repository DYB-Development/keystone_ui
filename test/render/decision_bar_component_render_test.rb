# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::DecisionBarComponentRenderTest < ViewComponent::TestCase
  def test_sends_its_note_and_the_pressed_action_to_the_address_it_is_given
    page = render_bar

    assert_equal "/approvals/7/decision", page.at_css("form[method='post']")&.[]("action")
  end

  def test_labels_its_note_field_with_the_label_it_is_given
    page = render_bar

    assert_equal "Note", page.at_css("label:has(input[name='note'])")&.text&.strip
  end

  def test_draws_each_secondary_action_as_a_button_sending_its_name_and_value
    page = render_bar

    assert_equal %w[reject send_back], page.css("form button.ks-button-secondary[name='decision']").map { |button| button["value"] }
  end

  def test_draws_the_primary_action_after_the_secondary_actions
    page = render_bar

    assert_equal [ "Reject", "Send back with findings", "Approve all 3" ], page.css("form button").map { |button| button.text.strip }
  end

  def test_lays_its_field_and_buttons_on_one_line_that_wraps_when_it_runs_out_of_width
    page = render_bar

    assert_empty %w[flex flex-wrap items-center] - page.at_css("form")["class"].to_s.split
  end

  def test_its_note_field_grows_into_the_width_the_buttons_leave
    page = render_bar

    assert_empty %w[flex-1 basis-60] - page.at_css("label:has(input[name='note'])")["class"].to_s.split
  end

  def test_given_a_hint_shows_it_on_a_line_of_its_own_under_the_buttons
    page = render_bar(hint: "Keyboard: A approve")

    assert_equal "Keyboard: A approve", page.at_css("form > .ks-hint.basis-full")&.text&.strip
  end

  def test_on_a_phone_draws_its_buttons_in_the_bottom_action_bar_fixed_above_the_bottom_navigation
    page = render_bar

    assert_equal 3, page.css("form .ks-bottom-action button").size
  end

  def test_from_640_pixels_wide_lays_the_fixed_bars_field_and_buttons_into_its_own_row
    page = render_bar

    assert_includes page.at_css(".ks-bottom-action")["class"].split, "sm:contents"
  end

  def test_on_a_phone_its_form_draws_no_box_of_its_own_around_the_fixed_bar
    page = render_bar

    assert_includes page.at_css("form")["class"].split, "max-sm:contents"
  end

  def test_from_640_pixels_wide_draws_its_row_in_a_panel
    page = render_bar

    assert_empty %w[ks-panel ks-panel-radius-md ks-panel-padding-sm] - page.at_css("form")["class"].split
  end

  def test_on_a_phone_stacks_its_buttons_in_a_column_with_even_gaps
    page = render_bar

    assert_empty %w[max-sm:flex-col ks-grid-gap-sm] - page.at_css(".ks-bottom-action")["class"].split
  end

  def test_on_a_phone_puts_the_primary_button_above_the_secondary_buttons
    page = render_bar

    assert_includes page.at_css(".ks-bottom-action > div:has(> button.ks-button-primary)")&.[]("class").to_s.split, "max-sm:order-first"
  end

  def test_on_a_phone_stretches_the_primary_button_across_the_full_width
    page = render_bar

    assert_includes page.at_css(".ks-bottom-action > div:has(> button.ks-button-primary)")&.[]("class").to_s.split, "max-sm:*:w-full"
  end

  def test_on_a_phone_makes_the_primary_button_48px_tall
    page = render_bar

    assert_includes page.at_css(".ks-bottom-action > div:has(> button.ks-button-primary)")&.[]("class").to_s.split, "max-sm:*:min-h-12"
  end

  def test_on_a_phone_gives_each_secondary_button_an_equal_share_of_the_row_under_the_primary_button
    page = render_bar

    assert_includes page.at_css("div:has(> button.ks-button-secondary)")&.[]("class").to_s.split, "max-sm:*:flex-1"
  end

  def test_on_a_phone_leaves_its_note_field_out_of_the_fixed_bar
    page = render_bar

    assert_includes page.at_css("label:has(input[name='note'])")["class"].split, "max-sm:hidden"
  end

  def test_on_a_phone_leaves_its_hint_out
    page = render_bar(hint: "Keyboard: A approve")

    assert_includes page.at_css(".ks-hint")["class"].split, "max-sm:hidden"
  end

  def test_keeps_a_copy_of_its_phone_bar_in_the_pages_flow_so_the_last_content_scrolls_clear_of_it
    page = render_bar

    assert_includes page.at_css("[data-decision-bar-spacer] .ks-bottom-action")&.[]("class").to_s.split, "!static"
  end

  def test_its_copy_in_the_pages_flow_cannot_be_seen_as_a_second_bar
    page = render_bar

    assert_includes page.at_css("[data-decision-bar-spacer] .ks-bottom-action")&.[]("class").to_s.split, "invisible"
  end

  private

  def render_bar(**overrides)
    render_inline(Keystone::Ui::DecisionBarComponent.new(**bar_args.merge(overrides)))
  end

  def bar_args
    {
      url: "/approvals/7/decision",
      note: { name: "note", label: "Note", placeholder: "Optional." },
      actions: [ { label: "Reject", name: "decision", value: "reject" }, { label: "Send back with findings", name: "decision", value: "send_back" } ],
      primary: { label: "Approve all 3", name: "decision", value: "approve" }
    }
  end
end
