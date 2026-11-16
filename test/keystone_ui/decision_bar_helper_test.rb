# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::DecisionBarHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component)
      @rendered = component
    end
  end

  def test_renders_a_decision_bar
    view = View.new

    view.ui_decision_bar(url: "/approvals/7/decision", primary: { label: "Approve" })

    assert_instance_of Keystone::Ui::DecisionBarComponent, view.rendered
  end
end
