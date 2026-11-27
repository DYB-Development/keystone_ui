# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::StatusLineComponentRenderTest < ViewComponent::TestCase
  def test_a_passing_line_starts_with_a_round_icon_labelled_pass
    page = render_inline(Keystone::Ui::StatusLineComponent.new(passed: true, text: "Customer gets back 2.4× the price, target 2×"))

    assert_equal "Pass", page.at_css(".ks-status-line .ks-status-icon.ks-status-icon-pass[role=img]")&.[]("aria-label")
  end

  def test_a_failing_line_starts_with_a_round_icon_labelled_fail
    page = render_inline(Keystone::Ui::StatusLineComponent.new(passed: false, text: "The scale check is short by $1,200"))

    assert_equal "Fail", page.at_css(".ks-status-line .ks-status-icon.ks-status-icon-fail[role=img]")&.[]("aria-label")
  end

  def test_a_passing_and_a_failing_icon_draw_different_marks
    marks = [ true, false ].map do |passed|
      render_inline(Keystone::Ui::StatusLineComponent.new(passed: passed, text: "Gross margin 40%")).at_css(".ks-status-icon svg[aria-hidden=true] path")&.[]("d")
    end

    assert_equal 2, marks.compact.uniq.size
  end

  def test_shows_its_sentence_after_the_icon
    page = render_inline(Keystone::Ui::StatusLineComponent.new(passed: true, text: "Gross margin 40%"))

    assert_equal "Gross margin 40%", page.at_css(".ks-status-line .ks-status-icon + span")&.text
  end

  def test_a_line_given_no_result_draws_no_icon
    page = render_inline(Keystone::Ui::StatusLineComponent.new(passed: nil, text: "Theoretical ceiling $9,000"))

    assert_nil page.at_css(".ks-status-line .ks-status-icon")
  end
end
