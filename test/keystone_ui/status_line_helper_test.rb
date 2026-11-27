# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::StatusLineHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component)
      @rendered = component
    end
  end

  def test_renders_a_status_line
    view = View.new

    view.ui_status_line(passed: true, text: "Gross margin 40%")

    assert_instance_of Keystone::Ui::StatusLineComponent, view.rendered
  end
end
