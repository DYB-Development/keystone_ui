# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::NavItemComponentTest < Minitest::Test
  def test_stores_label_and_href
    component = Keystone::Ui::NavItemComponent.new(label: "Dashboard", href: "/dashboard")

    assert_equal "Dashboard", component.label
    assert_equal "/dashboard", component.href
  end

  def test_returns_empty_string_for_link_classes_when_not_active
    component = Keystone::Ui::NavItemComponent.new(label: "Dashboard", href: "/dashboard")

    assert_equal "", component.link_classes
  end

  def test_returns_active_class_when_active
    component = Keystone::Ui::NavItemComponent.new(label: "Dashboard", href: "/dashboard", active: true)

    assert_equal "active", component.link_classes
  end
end
