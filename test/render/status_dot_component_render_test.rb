# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::StatusDotComponentRenderTest < ViewComponent::TestCase
  def test_draws_a_dot_coloured_for_its_state
    page = render_inline(Keystone::Ui::StatusDotComponent.new(state: :success, label: "Passed"))

    assert_equal 1, page.css(".ks-status-dot.ks-status-dot-success").size
  end

  def test_carries_its_label_for_screen_readers_without_showing_it
    page = render_inline(Keystone::Ui::StatusDotComponent.new(state: :success, label: "Passed"))

    assert_equal "Passed", page.at_css(".ks-status-dot .sr-only")&.text
  end

  def test_refuses_a_state_outside_the_five_naming_it
    error = assert_raises(ArgumentError) { Keystone::Ui::StatusDotComponent.new(state: :queued, label: "Queued") }

    assert_match(/queued/, error.message)
  end

  private
end
