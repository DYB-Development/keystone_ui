# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::CaptionComponentRenderTest < ViewComponent::TestCase
  def test_shows_its_text_as_a_caption
    page = render_inline(Keystone::Ui::CaptionComponent.new(text: "Work report"))

    assert_equal "Work report", page.css("p.ks-caption").text.strip
  end

  def test_a_link_toned_caption_is_drawn_in_the_link_colour
    page = render_inline(Keystone::Ui::CaptionComponent.new(text: "Geography", tone: :link))

    assert_equal "ks-caption ks-caption-link", page.at_css("p")["class"]
  end
end
