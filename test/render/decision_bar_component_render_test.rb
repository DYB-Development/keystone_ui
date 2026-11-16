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
