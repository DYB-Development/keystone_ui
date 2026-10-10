# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/keystone_ui/navigation_group"

class KeystoneUi::NavigationGroupTest < Minitest::Test
  def test_a_group_declared_standalone_says_so
    assert_predicate KeystoneUi::NavigationGroup.new("Home", standalone: true), :standalone?
  end
end
