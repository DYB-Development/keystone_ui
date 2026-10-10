# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/keystone_ui/navigation_group"
require_relative "../../lib/keystone_ui/visible_navigation"

class KeystoneUi::VisibleNavigationTest < Minitest::Test
  View = Struct.new(:role)

  def test_lists_the_groups_the_view_may_see_with_only_their_permitted_tabs
    sales = group("Sales", [ :quotes, ->(_view) { true } ], [ :refunds, ->(view) { view.role == :admin } ])
    admin = group("Admin", [ :users, ->(view) { view.role == :admin } ])

    groups = visible(sales, admin, view: View.new(:rep))

    assert_equal [ [ "Sales", [ "quotes" ] ] ], groups.map { |entry| [ entry.label, entry.tabs.map(&:label) ] }
  end

  def test_lists_the_groups_and_their_tabs_in_the_saved_order
    sales = group("Sales", [ :quotes, ->(_view) { true } ], [ :orders, ->(_view) { true } ])
    admin = group("Admin", [ :users, ->(_view) { true } ])
    saved_order = [ { "group" => "Admin" }, { "group" => "Sales", "tabs" => [ "orders" ] } ]

    groups = visible(sales, admin, view: View.new(:rep), saved_order: saved_order)

    assert_equal [ [ "Admin", [ "users" ] ], [ "Sales", [ "orders", "quotes" ] ] ], groups.map { |entry| [ entry.label, entry.tabs.map(&:label) ] }
  end

  def test_gives_each_tab_the_link_its_declaration_returns_for_the_view
    sales = KeystoneUi::NavigationGroup.new("Sales")
    sales.tab(:quotes, label: "Quotes", href: ->(view) { "/#{view.role}/quotes" }, permitted: ->(_view) { true })
    sales.tab(:orders, label: "Orders", href: "/orders", permitted: ->(_view) { true })

    groups = visible(sales, view: View.new(:rep))

    assert_equal [ "/rep/quotes", "/orders" ], groups.first.tabs.map(&:href)
  end

  def test_marks_only_the_tab_whose_key_is_the_current_tab_as_active
    sales = group("Sales", [ :quotes, ->(_view) { true } ], [ :orders, ->(_view) { true } ])

    groups = visible(sales, view: View.new(:rep), current_tab: :orders)

    assert_equal [ false, true ], groups.first.tabs.map(&:active)
  end

  private

  def visible(*groups, view:, saved_order: [], current_tab: nil)
    KeystoneUi::VisibleNavigation.new(groups, view: view, saved_order: saved_order, current_tab: current_tab).groups
  end

  def group(label, *tabs)
    KeystoneUi::NavigationGroup.new(label).tap do |declared|
      tabs.each { |key, permitted| declared.tab(key, label: key.to_s, href: "/#{key}", permitted: permitted) }
    end
  end
end
