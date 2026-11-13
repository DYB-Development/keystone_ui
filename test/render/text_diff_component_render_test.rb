# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::TextDiffComponentRenderTest < ViewComponent::TestCase
  def test_shows_the_first_version_on_the_left_and_the_second_on_the_right
    page = render_inline(Keystone::Ui::TextDiffComponent.new(before: "one\ntwo", after: "one\ntwo"))

    assert_equal [ %w[one two], %w[one two] ], [ texts(page, "before"), texts(page, "after") ]
  end

  def test_puts_shared_lines_on_the_same_row_with_a_blank_cell_opposite_each_removed_or_added_line
    page = render_inline(Keystone::Ui::TextDiffComponent.new(before: "a\nb\nc", after: "a\nc\nd"))

    assert_equal [ [ "a", "b", "c", "" ], [ "a", "", "c", "d" ] ], [ texts(page, "before"), texts(page, "after") ]
  end

  def test_marks_a_line_only_the_first_version_has_as_removed_on_the_left
    page = render_inline(Keystone::Ui::TextDiffComponent.new(before: "a\nb\nc", after: "a\nc\nd"))

    assert_equal [ "b" ], marked(page, "before", "ks-diff-removed")
  end

  def test_marks_a_line_the_second_version_adds_as_added_on_the_right
    page = render_inline(Keystone::Ui::TextDiffComponent.new(before: "a\nb\nc", after: "a\nc\nd"))

    assert_equal [ "d" ], marked(page, "after", "ks-diff-added")
  end

  def test_starts_each_removed_line_with_a_minus_and_each_added_line_with_a_plus
    page = render_inline(Keystone::Ui::TextDiffComponent.new(before: "a\nb\nc", after: "a\nc\nd"))

    assert_equal [ [ "", "-", "", "" ], [ "", "", "", "+" ] ], [ column(page, "before", "sign"), column(page, "after", "sign") ]
  end

  private

  def marked(page, side, mark)
    page.css("[data-diff-side='#{side}'] [data-diff-row].#{mark} [data-diff-text]").map(&:text)
  end

  def column(page, side, part)
    page.css("[data-diff-side='#{side}'] [data-diff-row]").map { |row| row.at_css("[data-diff-#{part}]")&.text.to_s }
  end

  def texts(page, side)
    page.css("[data-diff-side='#{side}'] [data-diff-row] [data-diff-text]").map(&:text)
  end
end
