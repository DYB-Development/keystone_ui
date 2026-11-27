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

  def test_a_select_field_given_include_blank_false_offers_no_empty_choice
    page = render_inline(Keystone::Ui::FormFieldComponent.new(attribute: "offer[plan]", type: :select, include_blank: false, options: [ [ "Monthly", "monthly" ], [ "Yearly", "yearly" ] ]))

    assert_equal [ "monthly", "yearly" ], page.css("select option").map { |option| option["value"] }
  end

  def test_a_checkbox_fields_words_are_the_label_of_its_checkbox
    page = render_inline(Keystone::Ui::FormFieldComponent.new(attribute: "player[accepted_terms]", label: "I accept the terms", type: :checkbox))
    checkbox_id = page.at_css("input[type=checkbox]")["id"]

    assert_equal "I accept the terms", page.at_css("label[for='#{checkbox_id}']")&.text
  end

  def test_a_required_checkbox_field_marks_its_checkbox_required_so_the_browser_will_not_submit_it_unticked
    page = render_inline(Keystone::Ui::FormFieldComponent.new(attribute: "player[accepted_terms]", label: "I accept the terms", type: :checkbox, required: true))

    assert page.at_css("input[type=checkbox]").key?("required")
  end

  def test_a_field_given_a_prefix_draws_it_before_its_input_inside_the_fields_border
    page = render_inline(Keystone::Ui::FormFieldComponent.new(attribute: "price[market]", type: :number, prefix: "$"))

    assert_equal "$", page.at_css(".ks-input-group > .ks-input-addon:first-child + input")&.previous_element&.text
  end

  def test_a_field_given_a_suffix_draws_it_after_its_input_inside_the_fields_border
    page = render_inline(Keystone::Ui::FormFieldComponent.new(attribute: "value[hours]", type: :number, suffix: "hours"))

    assert_equal "hours", page.at_css(".ks-input-group > input + .ks-input-addon:last-child")&.text
  end
end
