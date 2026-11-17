# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::MobileHeaderComponentRenderTest < ViewComponent::TestCase
  def test_shows_the_title_it_is_given
    page = render_inline(Keystone::Ui::MobileHeaderComponent.new(title: "Invoice #42", back_url: "/invoices"))

    assert_equal "Invoice #42", page.at_css(".ks-mobile-header-title")&.text&.strip
  end

  def test_given_no_back_url_leaves_no_space_for_one_before_the_title
    page = render_inline(Keystone::Ui::MobileHeaderComponent.new(title: "Inbox", back_url: nil))

    assert page.at_css(".ks-mobile-header-title").parent.element_children.first["class"].split.include?("ks-mobile-header-title")
  end

  def test_given_no_back_url_shows_no_back_link
    page = render_inline(Keystone::Ui::MobileHeaderComponent.new(title: "Invoices", back_url: nil))

    assert_empty page.css("a")
  end

  def test_draws_the_back_arrow_and_title_in_one_row_with_the_pages_side_margin
    page = render_inline(Keystone::Ui::MobileHeaderComponent.new(title: "Invoices", back_url: "/"))

    assert_includes page.at_css(".ks-mobile-header-title").parent["class"].to_s.split, "ks-page"
  end

  def test_inside_the_navbar_leaves_the_arrow_and_title_to_the_navbars_row
    page = render_inline(Keystone::Ui::MobileHeaderComponent.new(title: "Invoices", back_url: "/"))

    assert_includes page.at_css(".ks-mobile-header-title").parent["class"].split, "max-lg:in-[.top-nav]:contents"
  end

  def test_draws_the_badge_it_is_given
    page = render_inline(Keystone::Ui::MobileHeaderComponent.new(title: "Approve variants", back_url: nil, badge: { label: "46h left", variant: :warning }))

    assert_equal "46h left", page.at_css(".ks-badge-warning").text
  end

  def test_pushes_the_badge_to_the_right_end_of_the_header
    page = render_inline(Keystone::Ui::MobileHeaderComponent.new(title: "Approve variants", back_url: nil, badge: { label: "46h left" }))

    assert_includes page.at_css(".ks-badge")["class"].split, "ml-auto"
  end

  def test_keeps_the_badge_at_its_full_width_beside_a_long_title
    page = render_inline(Keystone::Ui::MobileHeaderComponent.new(title: "Approve variants", back_url: nil, badge: { label: "46h left" }))

    assert_includes page.at_css(".ks-badge")["class"].split, "shrink-0"
  end

  def test_shows_the_overline_above_the_title
    page = render_inline(Keystone::Ui::MobileHeaderComponent.new(title: "Approve variants", back_url: nil, overline: "Inbox · 7 items"))

    assert_equal "Inbox · 7 items", page.at_css(".ks-mobile-header-title").first_element_child.text
  end

  def test_keeps_the_badge_at_its_own_height_inside_a_taller_bar
    page = render_inline(Keystone::Ui::MobileHeaderComponent.new(title: "Approve variants", back_url: nil, badge: { label: "46h left" }))

    assert_includes page.at_css(".ks-badge")["class"].split, "self-center"
  end
end
