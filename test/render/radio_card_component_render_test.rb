# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::RadioCardComponentRenderTest < ViewComponent::TestCase
  def test_a_card_given_info_offers_an_info_button_beside_its_label
    page = render_inline(Keystone::Ui::RadioCardComponent.new(name: "kind", value: "anti", label: "Anti-guarantee", info: "No refunds, said as a reason to buy"))

    assert_equal "About Anti-guarantee", page.at_css("button.ks-radio-card-info")&.[]("aria-label")
  end

  def test_a_card_given_info_holds_it_in_a_panel
    page = render_inline(Keystone::Ui::RadioCardComponent.new(name: "kind", value: "anti", label: "Anti-guarantee", info: "No refunds, said as a reason to buy"))

    assert_equal "No refunds, said as a reason to buy", page.at_css(".ks-radio-card-disclosure")&.text&.strip
  end

  def test_tapping_the_info_button_toggles_the_panel
    page = render_inline(Keystone::Ui::RadioCardComponent.new(name: "kind", value: "anti", label: "Anti-guarantee", info: "No refunds"))

    assert_equal [ "stat-card-info", "click->stat-card-info#toggle", "panel" ],
      [ page.at_css("label")["data-controller"], page.at_css("button.ks-radio-card-info")["data-action"], page.at_css(".ks-radio-card-disclosure")["data-stat-card-info-target"] ]
  end
end
