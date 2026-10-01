# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::InfoComponentRenderTest < ViewComponent::TestCase
  def test_an_info_offers_a_button_to_learn_more
    page = render_inline(Keystone::Ui::InfoComponent.new(summary: "Price minus cost of goods"))

    assert_equal "More about this", page.at_css("button.ks-radio-card-info")&.[]("aria-label")
  end
end
