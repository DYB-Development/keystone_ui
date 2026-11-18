# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::LinkComponentRenderTest < ViewComponent::TestCase
  def test_draws_its_label_as_a_link_in_the_link_colour
    page = render_inline(Keystone::Ui::LinkComponent.new(label: "Upload questions", href: "/questions/upload"))

    assert_equal [ "Upload questions", "/questions/upload" ], [ page.at_css("a.ks-link")&.text, page.at_css("a.ks-link")&.[]("href") ]
  end

  def test_centred_draws_the_link_as_its_own_line_with_its_label_in_the_middle
    page = render_inline(Keystone::Ui::LinkComponent.new(label: "Finish on desktop", href: "/runs/1", centred: true))

    assert_equal "ks-link block text-center", page.at_css("a")["class"]
  end
end
