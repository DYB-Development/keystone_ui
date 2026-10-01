# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::FormFieldComponentRenderTest < ViewComponent::TestCase
  def test_a_field_given_suggestions_offers_each_while_typing
    page = render_inline(Keystone::Ui::FormFieldComponent.new(attribute: "answers[occupation]", label: "What do they do for work?", suggestions: [ "Nurse", "Teacher" ]))
    list = page.at_css("datalist##{page.at_css("input")["list"]}")

    assert_equal [ "Nurse", "Teacher" ], list&.css("option")&.map { |option| option["value"] }
  end
end
