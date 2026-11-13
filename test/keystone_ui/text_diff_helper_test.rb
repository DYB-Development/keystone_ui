# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::TextDiffHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component)
      @rendered = component
    end
  end

  def test_renders_a_text_diff
    view = View.new

    view.ui_text_diff(before: "a", after: "b")

    assert_instance_of Keystone::Ui::TextDiffComponent, view.rendered
  end
end
