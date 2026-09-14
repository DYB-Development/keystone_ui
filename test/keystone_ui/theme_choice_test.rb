# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/keystone_ui/theme_choice"

class KeystoneUi::ThemeChoiceTest < Minitest::Test
  def test_a_dark_choice_marks_the_page_dark
    assert_equal({ "data-theme" => "dark" }, KeystoneUi::ThemeChoice.new("dark").html_attributes)
  end

  def test_no_choice_leaves_the_page_following_the_operating_system
    assert_equal({}, KeystoneUi::ThemeChoice.new(nil).html_attributes)
  end
end
