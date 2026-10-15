# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ColorPickerComponentRenderTest < ViewComponent::TestCase
  def test_a_picker_shows_a_text_field_holding_its_value
    page = render_inline(Keystone::Ui::ColorPickerComponent.new(name: "accent", value: "oklch(0.62 0.19 259)"))

    assert_equal "oklch(0.62 0.19 259)", page.at_css("input[type=text].ks-input")&.[]("value")
  end

  def test_a_picker_shows_its_value_only_in_the_text_field
    page = render_inline(Keystone::Ui::ColorPickerComponent.new(name: "accent", value: "#3b82f6"))

    refute_includes page.text, "#3b82f6"
  end

  def test_typing_in_the_text_field_hands_the_colour_to_the_picker
    page = render_inline(Keystone::Ui::ColorPickerComponent.new(name: "accent"))

    assert_equal "input->color-picker#textChanged", page.at_css("input[type=text]")&.[]("data-action")
  end

  def test_a_picker_given_hex_draws_it_on_the_swatch_and_submits_it_under_its_name
    page = render_inline(Keystone::Ui::ColorPickerComponent.new(name: "accent", value: "#3b82f6"))

    assert_equal [ "background-color: #3b82f6;", "#3b82f6" ],
      [ page.at_css("button.ks-color-swatch")&.[]("style"), page.at_css("input[type=hidden][name=accent]")&.[]("value") ]
  end
end
