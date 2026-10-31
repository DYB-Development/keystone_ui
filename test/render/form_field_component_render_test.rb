# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::FormFieldComponentRenderTest < ViewComponent::TestCase
  def test_a_field_given_suggestions_offers_each_while_typing
    page = render_inline(Keystone::Ui::FormFieldComponent.new(attribute: "answers[occupation]", label: "What do they do for work?", suggestions: [ "Nurse", "Teacher" ]))
    list = page.at_css("datalist##{page.at_css("input")["list"]}")

    assert_equal [ "Nurse", "Teacher" ], list&.css("option")&.map { |option| option["value"] }
  end

  def test_a_field_without_suggestions_links_to_no_list
    page = render_inline(Keystone::Ui::FormFieldComponent.new(attribute: "answers[occupation]", label: "What do they do for work?"))

    assert_equal [ nil, nil ], [ page.at_css("input")["list"], page.at_css("datalist") ]
  end

  def test_a_fields_label_names_its_input
    page = render_inline(Keystone::Ui::FormFieldComponent.new(attribute: "player[email]", type: :email))

    assert_equal page.at_css("input")["id"], page.at_css("label")["for"]
  end

  def test_a_textarea_fields_label_names_its_textarea
    page = render_inline(Keystone::Ui::FormFieldComponent.new(attribute: "player[bio]", type: :textarea))

    assert_equal page.at_css("label")["for"], page.at_css("textarea")["id"]
  end

  def test_a_select_fields_label_names_its_select
    page = render_inline(Keystone::Ui::FormFieldComponent.new(attribute: "player[team_id]", type: :select, options: [ [ "Red", "1" ] ]))

    assert_equal page.at_css("label")["for"], page.at_css("select")["id"]
  end
end
