# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::CheckboxRowComponentRenderTest < ViewComponent::TestCase
  def test_a_row_given_info_offers_an_info_button_beside_its_label
    page = render_inline(Keystone::Ui::CheckboxRowComponent.new(name: "conditions[]", value: "proof", label: "Shows proof", info: "They send photos of the work"))

    assert_equal "About Shows proof", page.at_css("button.ks-radio-card-info")&.[]("aria-label")
  end
end
