# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::ActionListHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component)
      @rendered = component
    end
  end

  def test_renders_an_action_list
    view = View.new

    view.ui_action_list(rows: [ { text: "Lower the price to $2,400." } ])

    assert_instance_of Keystone::Ui::ActionListComponent, view.rendered
  end
end
