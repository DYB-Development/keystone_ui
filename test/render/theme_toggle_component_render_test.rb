# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ThemeToggleComponentRenderTest < ViewComponent::TestCase
  def test_is_one_button
    page = render_inline(Keystone::Ui::ThemeToggleComponent.new)

    assert_equal 1, page.css("button").size
  end

  def test_shows_a_sun_that_hides_in_dark_mode
    page = render_inline(Keystone::Ui::ThemeToggleComponent.new)

    assert_includes page.css("button svg[data-icon=sun]").first&.[]("class").to_s.split, "dark:hidden"
  end
end
