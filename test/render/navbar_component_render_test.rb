# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::NavbarComponentRenderTest < ViewComponent::TestCase
  def test_hide_logo_on_mobile_hides_the_logo_below_desktop_width
    page = render_navbar(hide_logo_on_mobile: true)

    assert_includes logo_classes(page), "hidden"
  end

  private

  def render_navbar(**options)
    render_inline(Keystone::Ui::NavbarComponent.new(**options)) do |navbar|
      navbar.with_logo { "MyApp" }
    end
  end

  def logo_classes(page)
    page.at_css(".logo")&.[]("class").to_s.split
  end
end
