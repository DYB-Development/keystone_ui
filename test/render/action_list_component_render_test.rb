# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ActionListComponentRenderTest < ViewComponent::TestCase
  def test_shows_each_rows_sentence_in_order
    page = render_inline(Keystone::Ui::ActionListComponent.new(rows: [ { text: "Lower the price to $2,400." }, { text: "Or raise actual value by $1,200." } ]))

    assert_equal [ "Lower the price to $2,400.", "Or raise actual value by $1,200." ], page.css("ul > li > span").map(&:text)
  end

  def test_a_rows_button_sends_its_own_request_from_the_right_of_its_sentence
    page = render_inline(Keystone::Ui::ActionListComponent.new(rows: [ { text: "Lower the price to $2,400.", button: { label: "Use", href: "/offers/1/price", method: :post } } ]))

    assert_equal [ "/offers/1/price", "Use" ], [ page.at_css("li > span + div form")&.[]("action"), page.at_css("li > span + div form button")&.text&.strip ]
  end
end
