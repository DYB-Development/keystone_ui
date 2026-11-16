# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::TextDiffComponentRenderTest < ViewComponent::TestCase
  def setup
    KeystoneUi.reset_configuration!
  end

  def teardown
    KeystoneUi.reset_configuration!
  end

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

  def test_numbers_each_columns_lines_in_its_own_version
    page = render_inline(Keystone::Ui::TextDiffComponent.new(before: "a\nb\nc", after: "a\nc\nd"))

    assert_equal [ [ "1", "2", "3", "" ], [ "1", "", "2", "3" ] ], [ column(page, "before", "number"), column(page, "after", "number") ]
  end

  def test_stacks_the_two_versions_on_a_phone_and_sets_them_side_by_side_from_640_pixels_wide
    page = render_inline(Keystone::Ui::TextDiffComponent.new(before: "a", after: "b"))

    assert_empty %w[grid grid-cols-1 sm:grid-cols-2] - page.at_css("[data-diff-side]").parent[:class].to_s.split
  end

  def test_shows_a_notice_that_the_texts_are_too_long_to_compare_when_they_run_past_2000_lines_together
    page = render_inline(Keystone::Ui::TextDiffComponent.new(before: lines(1001), after: lines(1000)))

    assert_equal "These texts are too long to compare.", page.at_css("[data-diff-notice]")&.text&.strip
  end

  def test_marks_no_line_when_the_texts_are_too_long_to_compare
    page = render_inline(Keystone::Ui::TextDiffComponent.new(before: lines(1001), after: lines(1000)))

    assert_empty page.css(".ks-diff-removed, .ks-diff-added")
  end

  def test_uses_the_line_limit_the_host_configured
    KeystoneUi.configure { |c| c.text_diff_line_limit = 10 }
    page = render_inline(Keystone::Ui::TextDiffComponent.new(before: lines(6), after: lines(5)))

    assert page.at_css("[data-diff-notice]")
  end

  def test_shows_a_notice_that_two_identical_texts_are_the_same
    page = render_inline(Keystone::Ui::TextDiffComponent.new(before: "one\ntwo", after: "one\ntwo"))

    assert_equal "These texts are the same.", page.at_css("[data-diff-notice]")&.text&.strip
  end

  def test_compares_a_text_with_windows_line_endings_as_equal_to_the_same_text_with_unix_line_endings
    page = render_inline(Keystone::Ui::TextDiffComponent.new(before: "one\r\ntwo\r\n", after: "one\ntwo\n"))

    assert_equal "These texts are the same.", page.at_css("[data-diff-notice]")&.text&.strip
  end

  def test_with_one_column_shows_each_removed_and_added_line_in_one_column_at_its_place_in_its_own_text
    page = render_inline(Keystone::Ui::TextDiffComponent.new(before: "a\nb\nc", after: "a\nc\nd", one_column: true))

    assert_equal %w[a b c d], page.css("[data-diff-column] [data-diff-row] [data-diff-text]").map(&:text)
  end

  def test_with_one_column_starts_a_removed_line_with_a_minus_an_added_line_with_a_plus_and_a_shared_line_with_neither
    page = render_inline(Keystone::Ui::TextDiffComponent.new(before: "a\nb\nc", after: "a\nc\nd", one_column: true))

    assert_equal [ "", "-", "", "+" ], page.css("[data-diff-column] [data-diff-row]").map { |row| row.at_css("[data-diff-sign]")&.text.to_s }
  end

  def test_with_one_column_colours_a_removed_line_as_removed
    page = render_inline(Keystone::Ui::TextDiffComponent.new(before: "a\nb\nc", after: "a\nc\nd", one_column: true))

    assert_equal [ "b" ], page.css("[data-diff-column] .ks-diff-removed [data-diff-text]").map(&:text)
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

  def lines(count)
    (1..count).map { |number| "line #{number}" }.join("\n")
  end
end
