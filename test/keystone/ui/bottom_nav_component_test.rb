# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::BottomNavComponentTest < Minitest::Test
  def test_includes_bottom_nav_in_nav_classes
    component = Keystone::Ui::BottomNavComponent.new

    assert_match(/(^|\s)ks-bottom-nav(\s|$)/, component.nav_classes)
  end

  def test_includes_lg_hidden_to_hide_on_desktop
    component = Keystone::Ui::BottomNavComponent.new

    assert_includes component.nav_classes, "lg:hidden"
  end

  def test_includes_hotwire_native_hidden_to_hide_in_native_apps
    component = Keystone::Ui::BottomNavComponent.new

    assert_includes component.nav_classes, "hotwire-native:hidden"
  end
end
