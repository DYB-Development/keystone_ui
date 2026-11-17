# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::CaptionComponentRenderTest < ViewComponent::TestCase
  def test_shows_its_text_as_a_caption
    page = render_inline(Keystone::Ui::CaptionComponent.new(text: "Work report"))

    assert_equal "Work report", page.css("p.ks-caption").text.strip
  end

  def test_a_normal_case_caption_is_drawn_in_the_case_it_was_written
    page = render_inline(Keystone::Ui::CaptionComponent.new(text: "Grey segment = queue time.", normal_case: true))

    assert_equal "ks-caption ks-caption-normal-case", page.at_css("p")["class"]
  end

  def test_a_caption_given_content_shows_its_links
    page = render_inline(Keystone::Ui::CaptionComponent.new(normal_case: true)) { '<a href="/requests/2041">REQ-2041</a> · copy_generation'.html_safe }

    assert_equal "/requests/2041", page.at_css("p.ks-caption a")&.[]("href")
  end

  def test_a_link_toned_caption_is_drawn_in_the_link_colour
    page = render_inline(Keystone::Ui::CaptionComponent.new(text: "Geography", tone: :link))

    assert_equal "ks-caption ks-caption-link", page.at_css("p")["class"]
  end
end
