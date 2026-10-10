# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/keystone_ui/navigation_order"

class KeystoneUi::NavigationOrderTest < Minitest::Test
  Group = Struct.new(:label)
  Tab = Struct.new(:key)

  def test_draws_the_groups_in_the_saved_order
    order = KeystoneUi::NavigationOrder.new([ { "group" => "Admin" }, { "group" => "Sales" } ])

    arranged = order.arrange([ group("Sales", :quotes), group("Admin", :users) ])

    assert_equal [ "Admin", "Sales" ], arranged.map { |group, _tabs| group.label }
  end

  def test_draws_the_tabs_of_a_group_in_the_saved_order
    order = KeystoneUi::NavigationOrder.new([ { "group" => "Sales", "tabs" => [ "orders", "quotes" ] } ])

    arranged = order.arrange([ group("Sales", :quotes, :orders) ])

    assert_equal [ [ :orders, :quotes ] ], arranged.map { |_group, tabs| tabs.map(&:key) }
  end

  private

  def group(label, *keys)
    [ Group.new(label), keys.map { |key| Tab.new(key) } ]
  end
end
