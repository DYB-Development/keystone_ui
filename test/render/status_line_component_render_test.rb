# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::StatusLineComponentRenderTest < ViewComponent::TestCase
  def test_a_passing_line_starts_with_a_round_icon_labelled_pass
    page = render_inline(Keystone::Ui::StatusLineComponent.new(passed: true, text: "Customer gets back 2.4× the price, target 2×"))

    assert_equal "Pass", page.at_css(".ks-status-line .ks-status-icon.ks-status-icon-pass[role=img]")&.[]("aria-label")
  end
end
