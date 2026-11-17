# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::LinkListComponentRenderTest < ViewComponent::TestCase
  def test_links_each_row_to_its_address_by_its_label
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "Monthly report", href: "/reports/abc" } ]))

    assert_equal "/reports/abc", page.css("a.ks-value-list-row", text: "Monthly report").attr("href").value
  end

  def test_shows_a_row_subtitle_as_a_note_under_its_label
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "Monthly report", href: "/reports/abc", subtitle: "October 2026" } ]))

    assert_equal "October 2026", page.css("a .ks-value-list-note").text.strip
  end

  def test_shows_a_row_value_after_its_label
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "Report PDF", href: "/products/abc", value: "2 downloads left" } ]))

    assert_equal "2 downloads left", page.css("a .ks-value-list-value").text.strip
  end

  def test_shows_a_row_badge_in_its_variant
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "October invoice", href: "/reports/abc", badge: { label: "Invoice", variant: :info } } ]))

    assert_equal "Invoice", page.css("a .ks-badge.ks-badge-info").text.strip
  end

  def test_ends_each_row_with_a_chevron
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "Monthly report", href: "/reports/abc" } ]))

    assert_equal 1, page.css("a.ks-value-list-row svg.ks-settings-link-chevron").size
  end

  def test_at_phone_width_stacks_a_row_badge_above_its_label
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "October invoice", href: "/reports/abc", badge: { label: "Invoice", variant: :info } } ]))

    assert_includes page.at_css("a .ks-badge").parent["class"].to_s.split, "flex-col-reverse"
  end

  def test_from_phone_width_up_sets_a_row_badge_beside_its_label
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "October invoice", href: "/reports/abc", badge: { label: "Invoice", variant: :info } } ]))

    assert_includes page.at_css("a > span")["class"].to_s.split, "sm:contents"
  end

  def test_at_phone_width_keeps_a_row_badge_to_its_own_width
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "October invoice", href: "/reports/abc", badge: { label: "Invoice", variant: :info } } ]))

    assert_includes page.at_css("a .ks-badge")["class"].to_s.split, "max-sm:self-start"
  end

  def test_at_phone_width_gives_a_row_label_the_free_width_of_its_row
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "October invoice", href: "/reports/abc", badge: { label: "Invoice", variant: :info } } ]))

    assert_includes page.at_css("a > span")["class"].to_s.split, "flex-1"
  end

  def test_at_phone_width_wraps_a_long_row_label_inside_its_row
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "October invoice", href: "/reports/abc", badge: { label: "Invoice", variant: :info } } ]))

    assert_includes page.at_css("a > span")["class"].to_s.split, "min-w-0"
  end

  def test_at_phone_width_spaces_a_row_badge_from_its_label
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "October invoice", href: "/reports/abc", badge: { label: "Invoice", variant: :info } } ]))

    assert_includes page.at_css("a > span")["class"].to_s.split, "ks-grid-gap-sm"
  end

  def test_shows_a_row_top_line_badge_apart_from_the_row_badge
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "3 subject-line variants", href: "/items/abc", top_line: { badge: { label: "approval", variant: :warning }, text: "expires 46h" } } ]))

    assert_equal "approval", page.at_css(".ks-settings-link-label").previous_element.css(".ks-badge.ks-badge-warning").text.strip
  end

  def test_shows_a_row_top_line_text_after_its_top_line_badge
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "3 subject-line variants", href: "/items/abc", top_line: { badge: { label: "approval", variant: :warning }, text: "expires 46h" } } ]))

    assert_equal "expires 46h", page.at_css(".ks-settings-link-label").previous_element.at_css(".ks-badge").next_element.text.strip
  end

  def test_marks_a_current_row_with_aria_current
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "Pick target segment", href: "/items/abc", current: true } ]))

    assert_equal "true", page.at_css("a.ks-value-list-row")["aria-current"]
  end

  def test_keeps_a_row_top_line_on_one_line
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "3 subject-line variants", href: "/items/abc", top_line: { badge: { label: "approval", variant: :warning }, text: "expires 46h" } } ]))

    assert_includes page.at_css(".ks-settings-link-label").previous_element["class"].to_s.split, "whitespace-nowrap"
  end

  def test_cuts_off_a_long_row_top_line_text_inside_its_row
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "3 subject-line variants", href: "/items/abc", top_line: { badge: { label: "approval", variant: :warning }, text: "expires 46h" } } ]))

    assert_includes page.at_css(".ks-settings-link-label").previous_element.at_css(".ks-badge").next_element["class"].to_s.split, "truncate"
  end

  def test_wraps_a_long_top_line_badge_instead_of_squeezing_the_text_beside_it
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "Spring email", href: "/runs/abc", top_line: { badge: { label: "Paused · waiting on Approve the copy?", variant: :warning }, text: "Started 2m ago" } } ]))

    assert_equal [ true, true ], [ "min-w-0", "whitespace-normal" ].map { |name| page.at_css(".ks-badge")["class"].split.include?(name) }
  end

  def test_keeps_the_full_width_of_the_short_text_beside_a_top_line_badge
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "Spring email", href: "/runs/abc", top_line: { badge: { label: "Paused · waiting on Approve the copy?", variant: :warning }, text: "Started 2m ago" } } ]))

    assert_includes page.at_css(".ks-value-list-note")["class"].split, "shrink-0"
  end

  def test_marks_a_current_row_with_the_current_row_class
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "Pick target segment", href: "/items/abc", current: true } ]))

    assert_includes page.at_css("a.ks-value-list-row")["class"].to_s.split, "ks-value-list-row-current"
  end

  def test_leaves_off_each_row_chevron_when_asked
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "Monthly report", href: "/reports/abc" } ], chevron: false))

    assert_equal 0, page.css("a.ks-value-list-row svg.ks-settings-link-chevron").size
  end

  def test_a_list_set_to_open_in_a_new_tab_opens_every_row_link_in_a_new_browser_tab
    page = render_inline(Keystone::Ui::LinkListComponent.new(rows: [ { label: "Terms", href: "/terms" }, { label: "Privacy", href: "/privacy" } ], new_tab: true))

    assert_equal %w[_blank _blank], page.css("a.ks-value-list-row").map { |link| link["target"] }
  end
end
