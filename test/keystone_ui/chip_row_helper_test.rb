# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::ChipRowHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component)
      @rendered = component
    end
  end

  def test_renders_a_row_of_summary_chips
    view = View.new

    view.ui_chip_row(chips: [ { label: "Checks", value: "4/4", tone: :success } ])

    assert_instance_of Keystone::Ui::ChipRowComponent, view.rendered
  end
end
