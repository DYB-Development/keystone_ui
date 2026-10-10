# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::NavigationComponentRenderTest < ViewComponent::TestCase
  def teardown
    KeystoneUi.reset_configuration!
  end

  def test_draws_the_page_content_a_layout_passes_below_the_top_bar
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])

    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal "Page", page.at_css("nav ~ p")&.text
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

  private

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
