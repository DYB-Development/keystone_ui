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
end
