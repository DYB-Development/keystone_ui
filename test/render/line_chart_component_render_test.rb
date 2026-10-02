# frozen_string_literal: true

require "render_helper"
require "date"

class Keystone::Ui::LineChartComponentRenderTest < ViewComponent::TestCase
  def test_a_chart_given_dates_tells_its_controller_the_axis_holds_days
    page = render_inline(Keystone::Ui::LineChartComponent.new(series: [], dates: [ Date.new(2026, 6, 10) ]))

    assert_equal "true", page.at_css("[data-controller='line-chart']")["data-line-chart-dated-value"]
  end
end
