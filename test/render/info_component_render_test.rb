# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::InfoComponentRenderTest < ViewComponent::TestCase
  def test_an_info_offers_a_button_to_learn_more
    page = render_inline(Keystone::Ui::InfoComponent.new(summary: "Price minus cost of goods"))

    assert_equal "More about this", page.at_css("button.ks-radio-card-info")&.[]("aria-label")
  end

  def test_hovering_the_button_shows_the_summary
    page = render_inline(Keystone::Ui::InfoComponent.new(summary: "Price minus cost of goods"))
    tip = page.at_css(".ks-info-summary")

    assert_equal [ "Price minus cost of goods", true, true ], [ tip&.text&.strip, tip&.[]("class").to_s.split.include?("hidden"), tip&.[]("class").to_s.split.include?("peer-hover:block") ]
  end
end
