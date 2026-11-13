# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::StatusDotComponentRenderTest < ViewComponent::TestCase
  def test_draws_a_dot_coloured_for_its_state
    page = render_inline(Keystone::Ui::StatusDotComponent.new(state: :success, label: "Passed"))

    assert_equal 1, page.css(".ks-status-dot.ks-status-dot-success").size
  end

  private
end
