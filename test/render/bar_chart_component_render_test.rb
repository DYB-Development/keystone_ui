# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::BarChartComponentRenderTest < ViewComponent::TestCase
  def test_draws_one_bar_for_each_bar_given_in_an_svg_from_the_server
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: 2 }, { label: "Tue", value: 4 } ]))

    assert_equal 2, page.css("svg rect.ks-bar-chart-bar").size
  end
end
