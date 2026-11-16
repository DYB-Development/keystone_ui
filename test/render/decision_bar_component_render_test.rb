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

    assert_equal %w[reject send_back], page.css("button.ks-button-secondary[name='decision']").map { |button| button["value"] }
  end

  def test_draws_the_primary_action_after_the_secondary_actions
    page = render_bar

    assert_equal [ "Reject", "Send back with findings", "Approve all 3" ], page.css("button").map { |button| button.text.strip }
  end

  def test_lays_its_field_and_buttons_on_one_line_that_wraps_when_it_runs_out_of_width
    page = render_bar

    assert_empty %w[flex flex-wrap items-center] - page.at_css("form")["class"].to_s.split
  end

  def test_its_note_field_grows_into_the_width_the_buttons_leave
    page = render_bar

    assert_empty %w[flex-1 basis-60] - page.at_css("label:has(input[name='note'])")["class"].to_s.split
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
