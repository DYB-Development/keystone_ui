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

  def test_draws_the_groups_the_saved_order_does_not_name_after_the_named_ones_in_declared_order
    order = KeystoneUi::NavigationOrder.new([ { "group" => "Admin" } ])

    arranged = order.arrange([ group("Sales", :quotes), group("Help", :guides), group("Admin", :users) ])

    assert_equal [ "Admin", "Sales", "Help" ], arranged.map { |group, _tabs| group.label }
  end

  def test_draws_the_tabs_the_saved_order_does_not_name_after_the_named_ones_in_declared_order
    order = KeystoneUi::NavigationOrder.new([ { "group" => "Sales", "tabs" => [ "refunds" ] } ])

    arranged = order.arrange([ group("Sales", :quotes, :orders, :refunds) ])

    assert_equal [ [ :refunds, :quotes, :orders ] ], arranged.map { |_group, tabs| tabs.map(&:key) }
  end

  def test_ignores_a_group_and_a_tab_the_saved_order_names_that_are_no_longer_declared
    order = KeystoneUi::NavigationOrder.new([ { "group" => "Reports" }, { "group" => "Sales", "tabs" => [ "invoices", "orders" ] } ])

    arranged = order.arrange([ group("Admin", :users), group("Sales", :quotes, :orders) ])

    assert_equal [ [ "Sales", [ :orders, :quotes ] ], [ "Admin", [ :users ] ] ], arranged.map { |group, tabs| [ group.label, tabs.map(&:key) ] }
  end

  def test_draws_the_declared_order_when_the_saved_order_is_not_a_list
    order = KeystoneUi::NavigationOrder.new("Admin")

    arranged = order.arrange([ group("Sales", :quotes), group("Admin", :users) ])

    assert_equal [ "Sales", "Admin" ], arranged.map { |group, _tabs| group.label }
  end

  private

  def group(label, *keys)
    [ Group.new(label), keys.map { |key| Tab.new(key) } ]
  end
end
