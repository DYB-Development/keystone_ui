# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::PrintedNavigationTest < Minitest::Test
  def test_the_navbar_is_left_off_a_printed_page
    assert_includes Keystone::Ui::NavbarComponent.new.nav_classes.split, "print:hidden"
  end

  def test_the_bottom_nav_is_left_off_a_printed_page
    assert_includes Keystone::Ui::BottomNavComponent::NAV_CLASSES.split, "print:hidden"
  end

  def test_the_navigation_top_bar_is_left_off_a_printed_page
    assert_includes Keystone::Ui::NavigationComponent::TOP_BAR_CLASSES.split, "print:hidden"
  end

  def test_the_navigation_sidebar_is_left_off_a_printed_page
    assert_includes Keystone::Ui::NavigationComponent::SIDEBAR_CLASSES.split, "print:hidden"
  end
end
