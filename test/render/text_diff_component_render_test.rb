# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::TextDiffComponentRenderTest < ViewComponent::TestCase
  def test_shows_the_first_version_on_the_left_and_the_second_on_the_right
    page = render_inline(Keystone::Ui::TextDiffComponent.new(before: "one\ntwo", after: "one\ntwo"))

    assert_equal [ %w[one two], %w[one two] ], [ texts(page, "before"), texts(page, "after") ]
  end

  private

  def texts(page, side)
    page.css("[data-diff-side='#{side}'] [data-diff-row] [data-diff-text]").map(&:text)
  end
end
