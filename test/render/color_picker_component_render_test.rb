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
end
