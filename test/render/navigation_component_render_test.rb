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

  def test_hands_the_host_the_top_bar_and_the_page_content_inside_one_element
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])

    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal [ [ "nav", "p" ] ], page.element_children.map { |part| [ part.element_children.first&.at_css("nav.top-nav")&.name, part.element_children.last&.name ] }
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

  def test_draws_the_navigation_as_a_sidebar_right_of_the_page_content_when_the_saved_placement_is_right
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])
    save_placement("right")

    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal "Page", page.at_xpath(".//*[contains(concat(' ', @class, ' '), ' ks-sidebar ')]/preceding-sibling::*[1]/p")&.text
  end

  def test_draws_the_top_bar_when_the_saved_placement_is_top_missing_or_unknown
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])

    drawn = [ "top", nil, "bottom" ].map do |placement|
      save_placement(placement)
      page = render_navigation { "<p>Page</p>".html_safe }
      [ page.css("nav.top-nav").size, page.css(".ks-sidebar").size ]
    end

    assert_equal [ [ 1, 0 ], [ 1, 0 ], [ 1, 0 ] ], drawn
  end

  def test_shows_each_visible_group_label_in_the_sidebar_above_its_visible_tabs
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ], [ :refunds, "Refunds", "/refunds", ->(_view) { false } ], [ :orders, "Orders", "/orders" ])
    declare_group("Admin", [ :users, "Users", "/users", ->(_view) { false } ])
    declare_group("Help", [ :guides, "Guides", "/guides" ])
    save_placement("left")

    page = render_navigation { "<p>Page</p>".html_safe }

    groups = page.css(".ks-sidebar > div").map { |group| group.element_children.map { |part| [ part["class"], part.text.strip, part["href"] ] } }
    assert_equal [ [ [ "ks-sidebar-group-label", "Sales", nil ], [ "ks-sidebar-tab", "Quotes", "/quotes" ], [ "ks-sidebar-tab", "Orders", "/orders" ] ], [ [ "ks-sidebar-group-label", "Help", nil ], [ "ks-sidebar-tab", "Guides", "/guides" ] ] ], groups
  end

  def test_hides_the_sidebar_and_leaves_the_page_content_full_width_below_the_desktop_width
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])
    save_placement("left")

    page = render_navigation { "<p>Page</p>".html_safe }

    sidebar = page.at_css(".ks-sidebar")
    assert_equal [ [], [ "lg:flex" ] ], [ %w[hidden lg:flex] - sidebar["class"].split, sidebar.parent["class"].split ]
  end

  def test_shows_the_logo_at_the_top_of_the_sidebar_and_the_menus_pushed_to_its_bottom
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])
    save_placement("right")

    page = render_navigation do |navigation|
      navigation.with_logo { "Acme" }
      navigation.with_menus { "Account" }
      "<p>Page</p>".html_safe
    end

    sidebar = page.at_css(".ks-sidebar")
    parts = sidebar.element_children
    assert_equal [ "Acme", "Account", true, true ], [ parts.first.text.strip, parts.last.text.strip, parts.last["class"].to_s.split.include?("mt-auto"), sidebar["class"].split.include?("lg:h-screen") ]
  end

  def test_wraps_the_logo_in_the_sidebar_logo_element_in_the_sidebar
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])
    save_placement("left")

    page = render_navigation do |navigation|
      navigation.with_logo { "Acme" }
      "<p>Page</p>".html_safe
    end

    assert_equal "Acme", page.at_css(".ks-sidebar .ks-sidebar-logo")&.text&.strip
  end

  def test_draws_only_the_page_content_when_the_saved_placement_is_a_side_and_nothing_is_left_to_show
    declare_group("Admin", [ :users, "Users", "/users", ->(_view) { false } ])
    save_placement("left")

    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal [ "p" ], page.element_children.map(&:name)
  end

  def test_draws_the_sidebar_holding_the_logo_and_menus_when_no_group_is_visible
    declare_group("Admin", [ :users, "Users", "/users", ->(_view) { false } ])
    save_placement("left")

    page = render_navigation do |navigation|
      navigation.with_logo { "Acme" }
      navigation.with_menus { "Account" }
      "<p>Page</p>".html_safe
    end

    assert_equal [ "Acme", "Account" ], page.css(".ks-sidebar > *").map { |part| part.text.strip }
  end

  def test_draws_the_top_bar_when_the_saved_value_holds_no_placement_entry
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: "left" } } }

    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal 1, page.css("nav.top-nav").size
  end

  def test_shows_the_tab_the_current_page_belongs_to_as_active_in_the_top_bar
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ], [ :orders, "Orders", "/orders" ])
    KeystoneUi.configure { |c| c.current_tab_supplier = ->(_view) { :orders } }

    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal [ "Orders" ], page.css(".ks-nav-item.active").map(&:text)
  end

  def test_shows_the_group_holding_the_current_page_tab_as_active_in_the_top_bar
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])
    declare_group("Admin", [ :users, "Users", "/users" ])
    KeystoneUi.configure { |c| c.current_tab_supplier = ->(_view) { :users } }

    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal [ "Admin" ], page.css(".ks-nav-dropdown-trigger.active").map { |menu| menu.text.strip }
  end

  def test_shows_the_tab_the_current_page_belongs_to_as_active_in_the_sidebar
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ], [ :orders, "Orders", "/orders" ])
    save_placement("left")
    KeystoneUi.configure { |c| c.current_tab_supplier = ->(_view) { :orders } }

    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal [ "Orders" ], page.css(".ks-sidebar-tab.active").map(&:text)
  end

  def test_shows_the_group_holding_the_current_page_tab_as_active_in_the_sidebar
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])
    declare_group("Admin", [ :users, "Users", "/users" ])
    save_placement("left")
    KeystoneUi.configure { |c| c.current_tab_supplier = ->(_view) { :users } }

    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal [ "Admin" ], page.css(".ks-sidebar-group-label.active").map(&:text)
  end

  def test_shows_nothing_as_active_on_a_page_that_belongs_to_no_declared_tab
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])
    KeystoneUi.configure { |c| c.current_tab_supplier = ->(_view) { :reports } }

    marked = [ "top", "left" ].map do |placement|
      save_placement(placement)
      render_navigation { "<p>Page</p>".html_safe }.css(".active").size
    end

    assert_equal [ 0, 0 ], marked
  end

  def test_shows_nothing_as_active_when_the_host_sets_no_current_tab_supplier
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])

    marked = [ "top", "left" ].map do |placement|
      save_placement(placement)
      render_navigation { "<p>Page</p>".html_safe }.css(".active").size
    end

    assert_equal [ 0, 0 ], marked
  end

  def test_draws_the_groups_in_the_saved_order_in_every_placement
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])
    declare_group("Admin", [ :users, "Users", "/users" ])

    drawn = [ "top", "left" ].map do |placement|
      save_navigation("placement" => placement, "order" => [ { "group" => "Admin" }, { "group" => "Sales" } ])
      page = render_navigation { "<p>Page</p>".html_safe }
      page.css(".ks-nav-dropdown button, .ks-sidebar-group-label").map { |label| label.text.strip }
    end

    assert_equal [ [ "Admin", "Sales" ], [ "Admin", "Sales" ] ], drawn
  end

  def test_shows_the_same_groups_tabs_order_and_active_marks_in_the_top_bar_and_the_sidebar
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ], [ :refunds, "Refunds", "/refunds", ->(_view) { false } ], [ :orders, "Orders", "/orders" ])
    declare_group("Admin", [ :users, "Users", "/users", ->(_view) { false } ])
    declare_group("Help", [ :guides, "Guides", "/guides" ])
    KeystoneUi.configure { |c| c.current_tab_supplier = ->(_view) { :orders } }
    order = [ { "group" => "Help" }, { "group" => "Sales", "tabs" => [ "orders" ] } ]

    top_bar, sidebar = [ "top", "left" ].map do |placement|
      save_navigation("placement" => placement, "order" => order)
      render_navigation { "<p>Page</p>".html_safe }
    end

    assert_equal drawn_in_top_bar(top_bar), drawn_in_sidebar(sidebar)
  end

  private

  def drawn_in_top_bar(page)
    page.css(".ks-nav-dropdown").map do |menu|
      trigger = menu.at_css(".ks-nav-dropdown-trigger")
      [ trigger.text.strip, trigger["class"].split.include?("active"), menu.css(".ks-nav-item").map { |tab| [ tab.text.strip, tab["href"], tab["class"].split.include?("active") ] } ]
    end
  end

  def drawn_in_sidebar(page)
    page.css(".ks-sidebar > div").map do |group|
      label = group.at_css(".ks-sidebar-group-label")
      [ label.text.strip, label["class"].split.include?("active"), group.css(".ks-sidebar-tab").map { |tab| [ tab.text.strip, tab["href"], tab["class"].split.include?("active") ] } ]
    end
  end

  def save_navigation(value)
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, key) { { value: value } if key == :navigation } }
  end

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
