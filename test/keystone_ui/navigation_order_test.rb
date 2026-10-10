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

  private

  def group(label, *keys)
    [ Group.new(label), keys.map { |key| Tab.new(key) } ]
  end
end
