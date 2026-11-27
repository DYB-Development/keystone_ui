# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::InputComponentRenderTest < ViewComponent::TestCase
  def test_an_input_given_a_prefix_draws_it_before_the_input_inside_its_border
    page = render_inline(Keystone::Ui::InputComponent.new(name: "price[market]", type: :number, prefix: "$"))

    assert_equal "$", page.at_css(".ks-input-group > .ks-input-addon:first-child + input")&.previous_element&.text
  end
end
