# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::WorkingHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component)
      @rendered = component
    end
  end

  def test_renders_the_working_behind_a_figure
    view = View.new

    view.ui_working(groups: [ { title: "Store runs", lines: [ { label: "Money a year", working: "$34.00 × 1,825", result: "$62,050.00" } ] } ])

    assert_equal "Store runs", view.rendered.groups.first.title
  end
end
