# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::BottomNavItemComponentTest < Minitest::Test
  def test_stores_label_href_and_icon
    component = Keystone::Ui::BottomNavItemComponent.new(label: "Home", href: "/", icon: "<svg></svg>")

    assert_equal "Home", component.label
    assert_equal "/", component.href
    assert_equal "<svg></svg>", component.icon
  end

  def test_returns_base_class_when_not_active
    component = Keystone::Ui::BottomNavItemComponent.new(label: "Home", href: "/", icon: "<svg></svg>")

    assert_equal "bottom-nav-item", component.item_classes
  end

  def test_includes_active_class_when_active
    component = Keystone::Ui::BottomNavItemComponent.new(label: "Home", href: "/", icon: "<svg></svg>", active: true)

    assert_equal "bottom-nav-item active", component.item_classes
  end
end
