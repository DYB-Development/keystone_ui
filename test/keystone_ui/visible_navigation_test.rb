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
