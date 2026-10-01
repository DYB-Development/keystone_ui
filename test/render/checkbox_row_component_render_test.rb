# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::CheckboxRowComponentRenderTest < ViewComponent::TestCase
  def test_a_row_given_info_offers_an_info_button_beside_its_label
    page = render_inline(Keystone::Ui::CheckboxRowComponent.new(name: "conditions[]", value: "proof", label: "Shows proof", info: "They send photos of the work"))

    assert_equal "About Shows proof", page.at_css("button.ks-radio-card-info")&.[]("aria-label")
  end

  def test_a_row_given_info_holds_it_in_a_panel_hidden_until_hovered
    page = render_inline(Keystone::Ui::CheckboxRowComponent.new(name: "conditions[]", value: "proof", label: "Shows proof", info: "They send photos of the work"))
    panel = page.at_css(".ks-radio-card-disclosure")

    assert_equal [ "They send photos of the work", true, true ], [ panel&.text&.strip, panel&.[]("class").to_s.split.include?("hidden"), panel&.[]("class").to_s.split.include?("peer-hover:block") ]
  end

  def test_tapping_a_rows_info_button_toggles_the_panel
    page = render_inline(Keystone::Ui::CheckboxRowComponent.new(name: "conditions[]", value: "proof", label: "Shows proof", info: "They send photos of the work"))

    assert_equal [ "stat-card-info", "click->stat-card-info#toggle", "panel" ],
      [ page.at_css("label")["data-controller"], page.at_css("button.ks-radio-card-info")["data-action"], page.at_css(".ks-radio-card-disclosure")["data-stat-card-info-target"] ]
  end
end
