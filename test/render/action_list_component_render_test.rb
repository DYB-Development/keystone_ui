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

  def test_a_rows_button_is_small_and_secondary_unless_it_says_otherwise
    page = render_inline(Keystone::Ui::ActionListComponent.new(rows: [ { text: "Lower the price to $2,400.", button: { label: "Use", name: "price", value: "2400" } } ]))

    assert_equal %w[ks-button ks-button-secondary ks-button-sm], page.at_css("li button")&.[]("class")&.split
  end

  def test_a_row_stacks_its_button_under_its_sentence_on_a_phone
    page = render_inline(Keystone::Ui::ActionListComponent.new(rows: [ { text: "Lower the price to $2,400." } ]))

    assert_includes page.at_css("li")&.[]("class")&.split, "max-sm:flex-col"
  end

  def test_a_rows_button_given_a_name_and_value_submits_the_form_around_the_list_with_them
    page = render_inline(Keystone::Ui::ActionListComponent.new(rows: [ { text: "Lower the price to $2,400.", button: { label: "Use", name: "price[price]", value: "2400" } } ]))

    assert_equal [ "submit", "price[price]", "2400", nil ], %w[type name value formaction].map { |name| page.at_css("li button")&.[](name) }
  end

  def test_a_compact_list_draws_each_row_in_small_text
    page = render_inline(Keystone::Ui::ActionListComponent.new(rows: [ { text: "Lower the price to $2,400." } ], compact: true))

    assert_includes page.at_css("li")&.[]("class")&.split, "text-sm"
  end

  def test_a_compact_list_keeps_each_rows_button_at_the_right_of_its_sentence_on_a_phone
    page = render_inline(Keystone::Ui::ActionListComponent.new(rows: [ { text: "Lower the price to $2,400." } ], compact: true))

    assert_equal [ false, true ], [ page.at_css("li")&.[]("class")&.split&.include?("max-sm:flex-col"), page.at_css("li")&.[]("class")&.split&.include?("items-center") ]
  end
end
