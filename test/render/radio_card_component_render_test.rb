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

  def test_the_info_button_shares_a_row_with_the_label
    page = render_inline(Keystone::Ui::RadioCardComponent.new(name: "kind", value: "anti", label: "Anti-guarantee", info: "No refunds"))

    assert_equal [ "Anti-guarantee", "About Anti-guarantee" ],
      [ page.at_css(".ks-radio-card-header .ks-radio-card-label")&.text, page.at_css(".ks-radio-card-header button")&.[]("aria-label") ]
  end

  def test_a_card_without_info_offers_no_info_button
    page = render_inline(Keystone::Ui::RadioCardComponent.new(name: "kind", value: "anti", label: "Anti-guarantee"))

    assert_nil page.at_css("button.ks-radio-card-info")
  end

  def test_a_card_given_submits_submits_its_form_when_chosen
    page = render_inline(Keystone::Ui::RadioCardComponent.new(name: "answers[1]", value: "b", label: "Paris", submits: true))

    assert_equal "this.form.requestSubmit()", page.at_css("input[type=radio]")["onchange"]
  end

  def test_a_card_given_show_value_draws_the_answers_value_before_its_label
    page = render_inline(Keystone::Ui::RadioCardComponent.new(name: "answers[1]", value: "b", label: "Paris", show_value: true))

    assert_equal [ "b", "Paris" ], [ page.at_css(".ks-radio-card .ks-radio-card-value")&.text, page.at_css(".ks-radio-card-value + span .ks-radio-card-label")&.text ]
  end

  def test_a_full_width_card_fills_its_row
    page = render_inline(Keystone::Ui::RadioCardComponent.new(name: "answers[1]", value: "b", label: "Paris", full_width: true))

    assert_equal "block cursor-pointer relative", page.at_css("label")["class"]
  end
end
