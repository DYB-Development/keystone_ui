# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ReadingHoldComponentRenderTest < ViewComponent::TestCase
  def test_the_end_marker_follows_the_content
    page = render_hold

    assert page.at_css("p.terms + span[data-reading-hold-target=end]")
  end

  def test_a_press_of_the_page_button_goes_through_the_hold_guard
    page = render_hold

    assert page.at_css("[data-action='click->reading-hold#guard'] button[data-reading-hold-target=button]")
  end

  def test_the_page_button_is_described_by_the_hold_status
    page = render_hold

    assert_equal page.at_css("[data-reading-hold-target=status]")["id"], page.at_css("button")["aria-describedby"]
  end

  def test_the_announcement_is_read_out_politely
    page = render_hold

    assert_equal "polite", page.at_css("[data-reading-hold-target=announcer]")["aria-live"]
  end

  def test_the_end_report_fields_are_named_for_the_form
    page = render_hold

    assert_equal ["reading[end_reached]", "reading[end_in_view_on_load]"], page.css("input[type=hidden]").map { |field| field["name"] }
  end

  def test_without_javascript_the_page_button_is_available
    page = render_hold

    assert_nil page.at_css("button")["aria-disabled"]
  end

  private

  def render_hold
    hold = Keystone::Ui::ReadingHoldComponent.new(seconds: 30)
    render_inline(hold) do |component|
      component.with_action { vc_test_controller.view_context.tag.button("Accept", **hold.button_options) }
      vc_test_controller.view_context.tag.p("Terms", class: "terms")
    end
  end
end
