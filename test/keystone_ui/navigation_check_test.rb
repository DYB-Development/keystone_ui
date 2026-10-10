# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/keystone_ui/navigation_check"
require_relative "../../lib/keystone_ui/navigation_group"

class KeystoneUi::NavigationCheckTest < Minitest::Test
  def test_a_tab_with_no_label_stops_boot_naming_the_tab
    group = KeystoneUi::NavigationGroup.new("Work")
    group.tab :deals, label: nil, href: "/deals", permitted: ->(_view) { true }

    error = assert_raises(KeystoneUi::NavigationCheck::Error) do
      KeystoneUi::NavigationCheck.new(groups: [ group ]).call
    end

    assert_includes error.message, "deals"
  end
end
