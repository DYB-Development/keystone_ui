# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::ButtonRowHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component, &block)
      @rendered = component
    end
  end

  def test_renders_a_button_row
    view = View.new

    view.ui_button_row(equal_width: true) { "Edit" }

    assert_instance_of Keystone::Ui::ButtonRowComponent, view.rendered
  end
end
