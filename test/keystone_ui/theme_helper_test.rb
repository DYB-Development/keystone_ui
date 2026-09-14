# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/keystone_ui/theme_choice"
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
end
