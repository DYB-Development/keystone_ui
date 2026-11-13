# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::BottomActionHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component)
      @rendered = component
    end
  end

  def test_renders_a_bottom_action
    view = View.new

    view.ui_bottom_action

    assert_instance_of Keystone::Ui::BottomActionComponent, view.rendered
  end
end
