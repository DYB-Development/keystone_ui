# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::SelectComponentRenderTest < ViewComponent::TestCase
  def test_draws_a_choice_given_disabled_as_not_choosable
    page = render_inline(Keystone::Ui::SelectComponent.new(name: "offer[plan]", options: [ [ "Monthly", "monthly" ], [ "Yearly", "yearly", { disabled: true } ] ]))

    assert_equal [ "yearly" ], page.css("select option[disabled]").map { |option| option["value"] }
  end
end
