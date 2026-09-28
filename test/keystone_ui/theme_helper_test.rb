# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../lib/keystone_ui/theme_choice"
require_relative "../../lib/keystone_ui/look_choice"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::ThemeHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :cookies, :rendered

    def initialize(cookies)
      @cookies = cookies
    end

    def render(component)
      @rendered = component
    end
  end

  def test_the_toggle_shows_the_theme_stored_in_the_cookie_as_pressed
    view = View.new(KeystoneUi::ThemeChoice::COOKIE => "dark")

    view.ui_theme_toggle

    assert view.rendered.pressed?("dark")
  end

  def test_marks_the_html_tag_with_the_theme_stored_in_the_cookie
    view = View.new(KeystoneUi::ThemeChoice::COOKIE => "dark")

    assert_equal %(data-theme="dark"), view.keystone_theme_attributes
  end

  def test_marks_the_html_tag_with_a_supplied_mode_when_the_browser_has_no_choice
    KeystoneUi.configure { |c| c.theme_mode_supplier = ->(_view) { "dark" } }

    assert_equal %(data-theme="dark"), View.new({}).keystone_theme_attributes
  ensure
    KeystoneUi.reset_configuration!
  end

  def test_the_toggle_shows_a_supplied_mode_as_pressed_when_the_browser_has_no_choice
    KeystoneUi.configure { |c| c.theme_mode_supplier = ->(_view) { "dark" } }
    view = View.new({})

    view.ui_theme_toggle

    assert view.rendered.pressed?("dark")
  ensure
    KeystoneUi.reset_configuration!
  end

  def test_marks_the_html_tag_with_the_default_look_beside_the_theme
    KeystoneUi.configure do |c|
      c.register_look :plain, "/looks/plain.css"
      c.default_look = :plain
    end

    assert_equal %(data-theme="dark" data-look="plain"), View.new(KeystoneUi::ThemeChoice::COOKIE => "dark").keystone_theme_attributes
  ensure
    KeystoneUi.reset_configuration!
  end

  def test_marks_the_html_tag_with_the_look_a_supplier_reads_from_the_view
    KeystoneUi.configure do |c|
      c.register_look :plain, "/looks/plain.css"
      c.register_look :material, "/looks/material.css"
      c.default_look = :plain
      c.look_supplier = ->(view) { view.cookies["look"] }
    end

    assert_equal %(data-look="material"), View.new("look" => "material").keystone_theme_attributes
  ensure
    KeystoneUi.reset_configuration!
  end
end
