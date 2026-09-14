# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::CheckboxRowHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component)
      @rendered = component
    end
  end

  def test_renders_a_checkbox_row_with_the_given_label
    view = View.new

    view.ui_checkbox_row(name: "shown[]", value: "merged", label: "Merged")

    assert_equal "Merged", view.rendered.label
  end
end
