# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ParagraphComponentRenderTest < ViewComponent::TestCase
  def test_shows_its_text_as_a_paragraph
    page = render_inline(Keystone::Ui::ParagraphComponent.new(text: "Work from 1 to 30 September."))

    assert_equal "Work from 1 to 30 September.", page.css("p.ks-paragraph").text.strip
  end
end
