# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::PictureComponentRenderTest < ViewComponent::TestCase
  def test_shows_the_picture_at_its_address_with_its_description
    page = render_inline(Keystone::Ui::PictureComponent.new(src: "/pictures/eiffel.jpg", alt: "The Eiffel Tower"))

    assert_equal [ [ "/pictures/eiffel.jpg", "The Eiffel Tower" ] ], page.css("img").map { |img| [ img["src"], img["alt"] ] }
  end

  def test_a_picture_is_never_taller_than_half_the_screen
    page = render_inline(Keystone::Ui::PictureComponent.new(src: "/pictures/eiffel.jpg", alt: "The Eiffel Tower"))

    assert_includes page.at_css("img")["class"].to_s.split, "max-h-[50svh]"
  end
end
