# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::PrintedNavigationTest < Minitest::Test
  def test_the_navbar_is_left_off_a_printed_page
    assert_includes Keystone::Ui::NavbarComponent.new.nav_classes.split, "print:hidden"
  end
end
