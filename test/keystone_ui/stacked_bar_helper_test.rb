# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::StackedBarHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component)
      @rendered = component
    end
  end

  def test_renders_a_stacked_bar
    view = View.new

    view.ui_stacked_bar(segments: [ { label: "COGS", amount: 600, tone: :blue } ])

    assert_instance_of Keystone::Ui::StackedBarComponent, view.rendered
  end
end
