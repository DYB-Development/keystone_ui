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

  def test_a_tab_with_no_link_stops_boot_naming_the_tab
    group = KeystoneUi::NavigationGroup.new("Work")
    group.tab :deals, label: "Deals", href: nil, permitted: ->(_view) { true }

    error = assert_raises(KeystoneUi::NavigationCheck::Error) do
      KeystoneUi::NavigationCheck.new(groups: [ group ]).call
    end

    assert_includes error.message, "deals"
  end

  def test_two_tabs_sharing_a_key_stop_boot_naming_the_key
    work = KeystoneUi::NavigationGroup.new("Work")
    work.tab :reports, label: "Reports", href: "/reports", permitted: ->(_view) { true }
    admin = KeystoneUi::NavigationGroup.new("Admin")
    admin.tab :reports, label: "Admin reports", href: "/admin/reports", permitted: ->(_view) { true }

    error = assert_raises(KeystoneUi::NavigationCheck::Error) do
      KeystoneUi::NavigationCheck.new(groups: [ work, admin ]).call
    end

    assert_includes error.message, "reports"
  end

  def test_a_group_with_no_tabs_stops_boot_naming_the_group
    error = assert_raises(KeystoneUi::NavigationCheck::Error) do
      KeystoneUi::NavigationCheck.new(groups: [ KeystoneUi::NavigationGroup.new("Admin") ]).call
    end

    assert_includes error.message, "Admin"
  end
end
