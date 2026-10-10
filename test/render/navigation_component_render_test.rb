# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::NavigationComponentRenderTest < ViewComponent::TestCase
  def teardown
    KeystoneUi.reset_configuration!
  end

  def test_draws_the_page_content_a_layout_passes_below_the_top_bar
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])

    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal "Page", page.at_xpath(".//nav[contains(@class, 'top-nav')]/following::p")&.text
  end

  def test_shows_each_group_as_a_menu_in_the_top_bar_holding_its_tabs_in_declared_order
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ], [ :orders, "Orders", "/orders" ])
    declare_group("Admin", [ :users, "Users", "/users" ])

    page = render_navigation { "<p>Page</p>".html_safe }

    menus = page.css("nav .lg\\:flex .ks-nav-dropdown").map { |menu| [ menu.at_css("button").text.strip, menu.css("a").map { |tab| [ tab.text, tab["href"] ] } ] }
    assert_equal [ [ "Sales", [ [ "Quotes", "/quotes" ], [ "Orders", "/orders" ] ] ], [ "Admin", [ [ "Users", "/users" ] ] ] ], menus
  end

  def test_links_a_tab_declared_with_a_callable_link_to_what_it_returns_for_the_view
    declare_group("Sales", [ :quotes, "Quotes", ->(view) { "/#{view.controller_name}/quotes" } ])

    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal "/application/quotes", page.at_css(".ks-nav-item")&.[]("href")
  end

  def test_hides_a_tab_whose_permission_check_fails_for_the_view
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ], [ :refunds, "Refunds", "/refunds", ->(view) { view.controller_name == "admin" } ])

    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal [ "Quotes" ], page.css(".ks-nav-item").map(&:text)
  end

  def test_hides_a_group_whose_tabs_are_all_hidden
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])
    declare_group("Admin", [ :users, "Users", "/users", ->(_view) { false } ])

    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal [ "Sales" ], page.css(".ks-nav-dropdown button").map { |menu| menu.text.strip }
  end

  def test_hides_the_top_bar_below_the_desktop_width
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])

    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal [ [] ], page.css("nav.top-nav").map { |bar| %w[hidden lg:block] - bar.parent["class"].to_s.split }
  end

  def test_draws_only_the_page_content_when_the_host_declares_no_navigation
    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal [ "p" ], page.element_children.map(&:name)
  end

  def test_shows_the_logo_a_layout_hands_it_at_the_left_end_of_the_top_bar
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])

    page = render_navigation do |navigation|
      navigation.with_logo { "Acme" }
      "<p>Page</p>".html_safe
    end

    assert_equal "Acme", page.at_css("nav.top-nav > *:first-child.logo")&.text&.strip
  end

  def test_shows_the_menus_a_layout_hands_it_after_the_tabs_at_the_right_end_of_the_top_bar
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])

    page = render_navigation do |navigation|
      navigation.with_menus { "Account" }
      "<p>Page</p>".html_safe
    end

    assert_equal "Account", page.at_css("nav.top-nav .lg\\:flex > nav:last-child:not(:first-child)")&.text&.strip
  end

  def test_holds_only_the_tabs_in_the_top_bar_when_the_layout_hands_it_no_logo_or_menus
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])

    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal [ [ "div", [ "nav" ] ] ], page.at_css("nav.top-nav").element_children.map { |part| [ part.name, part.element_children.map(&:name) ] }
  end

  def test_draws_the_top_bar_holding_the_logo_and_menus_when_no_group_is_visible
    declare_group("Admin", [ :users, "Users", "/users", ->(_view) { false } ])

    page = render_navigation do |navigation|
      navigation.with_logo { "Acme" }
      navigation.with_menus { "Account" }
      "<p>Page</p>".html_safe
    end

    assert_equal [ "Acme", "Account" ], [ page.at_css(".hidden.lg\\:block nav.top-nav .logo")&.text&.strip, page.at_css(".hidden.lg\\:block nav.top-nav .lg\\:flex > nav:last-child")&.text&.strip ]
  end

  def test_draws_the_navigation_as_a_sidebar_left_of_the_page_content_when_the_saved_placement_is_left
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])
    save_placement("left")

    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal "Page", page.at_xpath(".//*[contains(concat(' ', @class, ' '), ' ks-sidebar ')]/following-sibling::*[1]/p")&.text
  end

  private

  def save_placement(placement)
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, key) { { value: { "placement" => placement } } if key == :navigation } }
  end

  def declare_group(label, *tabs)
    KeystoneUi.configure do |c|
      c.navigation_group(label) do |group|
        tabs.each { |key, tab_label, href, permitted = ->(_view) { true }| group.tab(key, label: tab_label, href: href, permitted: permitted) }
      end
    end
  end

  def render_navigation(&page_content)
    Nokogiri::HTML.fragment(vc_test_view_context.ui_navigation(&page_content))
  end
end
