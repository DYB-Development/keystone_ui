# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::PageHeaderComponentRenderTest < ViewComponent::TestCase
  def test_given_only_an_action_address_draws_it_as_a_button
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Events", action_url: "/events/new", action_label: "Create"))

    assert_equal "Create", page.at_css(".ks-page-header-actions a[href='/events/new']")&.text
  end

  def test_given_an_action_method_posts_the_button_to_the_action_address
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Events", action_url: "/events", action_label: "Create", action_method: :post))

    assert_equal "post", page.at_css(".ks-page-header-actions form[action='/events']")&.[]("method")
  end

  def test_given_an_action_method_passes_it_to_the_layout
    method = render_in_view_context do
      ui_page_header(title: "Events", action_url: "/events", action_method: :post)
      content_for(:mobile_action_method)
    end

    assert_equal "post", method.text.strip
  end

  def test_given_no_action_method_passes_none_to_the_layout
    method_set = nil
    render_in_view_context do
      ui_page_header(title: "Events", action_url: "/events/new")
      method_set = content_for?(:mobile_action_method)
      nil
    end

    assert_equal false, method_set
  end

  def test_given_an_action_block_draws_only_the_block
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Events", action_url: "/events/new")) do |header|
      header.action { "Block" }
    end

    assert_equal [ "Block" ], page.css(".ks-page-header-actions").map { |actions| actions.text.strip }
  end

  def test_given_no_menu_lays_the_actions_out_side_by_side_from_desktop_width_up
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Events")) do |header|
      header.action { "Block" }
    end

    assert_includes page.at_css(".ks-page-header-actions")["class"].split, "sm:flex"
  end

  def test_wraps_action_buttons_that_do_not_fit_onto_another_line
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Order 12", badges: [ { label: "Paid" } ], menu: [ { label: "Edit", href: "/orders/12/edit" } ])) do |header|
      header.action { "Block" }
    end

    assert_includes page.at_css(".ks-page-header-actions")["class"].split, "flex-wrap"
  end

  def test_keeps_the_actions_no_wider_than_the_header
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Events")) do |header|
      header.action { "Block" }
    end

    assert_includes page.at_css(".ks-page-header-actions")["class"].split, "max-w-full"
  end

  def test_given_a_title_passes_it_to_the_layout
    title = render_in_view_context do
      ui_page_header(title: "Events")
      content_for(:mobile_page_title)
    end

    assert_equal "Events", title.text.strip
  end

  def test_given_no_title_passes_none_to_the_layout
    title_set = nil
    render_in_view_context do
      ui_page_header(title: nil)
      title_set = content_for?(:mobile_page_title)
      nil
    end

    assert_equal false, title_set
  end

  def test_given_badges_draws_each_beside_the_title_in_its_colour
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Order 12", badges: [ { label: "Paid", variant: :success } ]))

    assert_equal "Paid", page.at_css(".ks-page-header-title + .ks-badge.ks-badge-success")&.text
  end

  def test_given_menu_items_draws_them_in_an_action_menu_beside_the_actions
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Order 12", action_url: "/orders/12/edit", menu: [ { label: "Delete", href: "/orders/12", method: :delete } ]))

    assert_equal "/orders/12", page.at_css(".ks-page-header-actions [data-controller='action-menu'] form")&.[]("action")
  end

  def test_given_badges_shows_the_header_at_phone_width
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Order 12", badges: [ { label: "Paid" } ]))

    assert_includes page.at_css(".ks-page-header")["class"].split, "max-sm:flex"
  end

  def test_given_badges_and_an_action_shows_the_actions_side_by_side_at_phone_width
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Events", action_url: "/events/new", badges: [ { label: "Live" } ]))

    assert_includes page.at_css(".ks-page-header-actions")["class"].split, "max-sm:flex"
  end

  def test_given_badges_and_an_action_puts_the_actions_on_their_own_full_width_row_at_phone_width
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Events", action_url: "/events/new", badges: [ { label: "Live" } ]))

    assert_includes page.at_css(".ks-page-header-actions")["class"].split, "max-sm:basis-full"
  end

  def test_hides_its_title_at_phone_width_when_the_top_bar_shows_one
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Events", badges: [ { label: "Live" } ]))

    assert_includes page.at_css(".ks-page-header-title")["class"].split, "max-sm:[body:has(.ks-mobile-header-title)_&]:hidden"
  end

  def test_given_menu_items_shows_the_menu_at_phone_width
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Order 12", menu: [ { label: "Edit", href: "/orders/12/edit" } ]))

    assert_includes page.at_css(".ks-page-header-actions")["class"].split, "flex"
  end

  def test_given_no_badges_and_no_menu_draws_the_same_classes_from_phone_width_up
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Events", action_url: "/events/new", action_label: "Create"))
    classes = page.css(".ks-page-header, .ks-page-header *").map { |node| node["class"].to_s.split.reject { |name| name.start_with?("max-sm:") }.join(" ") }

    assert_equal [ "ks-page-header", "", "ks-page-header-title", "page-header-actions ks-page-header-actions sm:flex sm:items-center flex-wrap max-w-full ks-grid-gap-sm" ], classes.first(4)
  end

  def test_given_only_an_action_keeps_the_header_hidden_at_phone_width
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Events", action_url: "/events/new"))

    assert_equal [ "ks-page-header" ], page.at_css(".ks-page-header")["class"].split
  end

  def test_given_only_an_action_gives_the_actions_no_phone_width_classes
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Events", action_url: "/events/new"))

    assert_equal "page-header-actions ks-page-header-actions sm:flex sm:items-center flex-wrap max-w-full ks-grid-gap-sm", page.at_css(".ks-page-header-actions")["class"]
  end
end
