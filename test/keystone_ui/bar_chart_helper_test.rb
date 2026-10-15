# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::BarChartHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component)
      @rendered = component
    end
  end

  def test_renders_a_bar_chart_with_its_bars
    view = View.new

    view.ui_bar_chart(bars: [ { label: "Mon", value: 2 } ])

    assert_equal [ { label: "Mon", value: 2 } ], view.rendered.bars
  end
end
