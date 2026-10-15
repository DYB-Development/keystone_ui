# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::BarChartComponentRenderTest < ViewComponent::TestCase
  def test_draws_one_bar_for_each_bar_given_in_an_svg_from_the_server
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: 2 }, { label: "Tue", value: 4 } ]))

    assert_equal 2, page.css("svg rect.ks-bar-chart-bar").size
  end

  def test_draws_each_bar_as_tall_as_its_value_in_proportion_to_the_others
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: 2 }, { label: "Tue", value: 4 } ]))
    heights = page.css("rect.ks-bar-chart-bar").map { |bar| bar[:height].to_f }

    assert_in_delta 0.5, heights.first / heights.last, 0.001
  end

  def test_writes_each_bars_label_under_it
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: 2 }, { label: "Tue", value: 4 } ]))

    assert_equal %w[Mon Tue], page.css("text.ks-bar-chart-text[data-bar-label]").map(&:text)
  end

  def test_draws_a_bar_marked_as_shaded_shaded
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Fri", value: 2 }, { label: "Sat", value: 1, shaded: true } ]))

    assert_equal [ false, true ], page.css("rect.ks-bar-chart-bar").map { |bar| bar[:class].split.include?("ks-bar-chart-bar-shaded") }
  end
end
