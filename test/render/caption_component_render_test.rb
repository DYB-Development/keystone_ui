# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::CaptionComponentRenderTest < ViewComponent::TestCase
  def test_shows_its_text_as_a_caption
    page = render_inline(Keystone::Ui::CaptionComponent.new(text: "Work report"))

    assert_equal "Work report", page.css("p.ks-caption").text.strip
  end
end
