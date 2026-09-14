# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/keystone_ui/theme_choice"

class KeystoneUi::ThemeChoiceTest < Minitest::Test
  def test_a_dark_choice_marks_the_page_dark
    assert_equal({ "data-theme" => "dark" }, KeystoneUi::ThemeChoice.new("dark").html_attributes)
  end

  def test_no_choice_marks_the_page_light
    assert_equal({ "data-theme" => "light" }, KeystoneUi::ThemeChoice.new(nil).html_attributes)
  end

  def test_an_unknown_choice_marks_the_page_light
    assert_equal({ "data-theme" => "light" }, KeystoneUi::ThemeChoice.new("\"><script>").html_attributes)
  end

  def test_is_stored_in_the_cookie_the_toggle_controller_writes
    assert_equal "keystone_theme", KeystoneUi::ThemeChoice::COOKIE
  end

  def test_writes_the_mark_as_html_tag_attributes
    assert_equal %(data-theme="light"), KeystoneUi::ThemeChoice.new("light").html_attributes_markup
  end

  def test_is_read_from_the_same_cookie_the_toggle_controller_writes
    controller = File.read(File.expand_path("../../app/assets/javascripts/keystone_ui/theme_toggle_controller.js", __dir__))

    assert_includes controller, %(const COOKIE = "#{KeystoneUi::ThemeChoice::COOKIE}")
  end
end
