# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::EmptyStateHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component)
      @rendered = component
    end
  end

  def test_renders_an_empty_state
    view = View.new

    view.ui_empty_state(title: "No reports yet")

    assert_instance_of Keystone::Ui::EmptyStateComponent, view.rendered
  end
end
