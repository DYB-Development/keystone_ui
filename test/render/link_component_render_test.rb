# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::LinkComponentRenderTest < ViewComponent::TestCase
  def test_draws_its_label_as_a_link_in_the_link_colour
    page = render_inline(Keystone::Ui::LinkComponent.new(label: "Upload questions", href: "/questions/upload"))

    assert_equal [ "Upload questions", "/questions/upload" ], [ page.at_css("a.ks-section-action")&.text, page.at_css("a.ks-section-action")&.[]("href") ]
  end
end
