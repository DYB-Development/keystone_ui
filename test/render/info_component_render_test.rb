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

    assert_equal [ "Price minus cost of goods", true, "summary", "mouseenter->info#peek mouseleave->info#unpeek click->info#toggle" ],
      [ tip&.text&.strip, tip&.[]("class").to_s.split.include?("hidden"), tip&.[]("data-info-target"), page.at_css("button")["data-action"] ]
  end

  def test_clicking_the_button_opens_what_it_is_given_in_full
    page = render_inline(Keystone::Ui::InfoComponent.new(summary: "Price minus cost of goods")) { "Price $100.00, cost of goods $40.00" }
    panel = page.at_css(".ks-info-detail")

    assert_equal [ "Price $100.00, cost of goods $40.00", "detail", true ],
      [ panel&.text&.strip, panel&.[]("data-info-target"), panel&.[]("class").to_s.split.include?("hidden") ]
  end

  def test_an_info_closes_its_popups_on_a_click_elsewhere_or_a_scroll
    page = render_inline(Keystone::Ui::InfoComponent.new(summary: "Price minus cost of goods"))

    assert_equal [ "info", "click@window->info#hide scroll@window->info#close" ], [ page.at_css("[data-controller]")["data-controller"], page.at_css("[data-controller]")["data-action"] ]
  end
end
