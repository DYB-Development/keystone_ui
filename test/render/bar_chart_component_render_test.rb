# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::BarChartComponentRenderTest < ViewComponent::TestCase
  def test_draws_one_bar_for_each_bar_given_in_an_svg_from_the_server
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: 2 }, { label: "Tue", value: 4 } ]))

    assert_equal 2, page.css("svg rect.ks-bar-chart-bar").size
  end

  def test_refuses_a_negative_value_naming_it
    error = assert_raises(ArgumentError) { render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: 2 }, { label: "Tue", value: -3 } ])) }

    assert_includes error.message, "-3"
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

  def test_writes_each_bars_value_on_it_when_asked_to_show_values
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: "2.5" }, { label: "Tue", value: "4" } ], show_values: true))

    assert_equal %w[2.5 4], page.css("text.ks-bar-chart-value").map(&:text)
  end

  def test_labels_its_value_axis_in_round_steps_reaching_just_past_the_largest_value
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: "7.5" }, { label: "Tue", value: "3" } ]))

    assert_equal %w[0 2 4 6 8], page.css("text.ks-bar-chart-text[data-axis-tick]").map(&:text)
  end

  def test_labels_a_value_axis_of_fractions_without_rounding_noise
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: "0.7" } ]))

    assert_equal %w[0 0.2 0.4 0.6 0.8], page.css("text.ks-bar-chart-text[data-axis-tick]").map(&:text)
  end

  def test_draws_a_grid_line_at_each_step_of_its_value_axis
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: "7.5" } ]))

    assert_equal 5, page.css("line.ks-bar-chart-grid").size
  end

  def test_draws_its_text_outside_any_drawing_that_scales_with_the_charts_width
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: "2" } ], show_values: true))

    assert_equal [ 7, 0 ], [ page.css("svg text").size, page.css("svg[viewBox] text").size ]
  end

  def test_labels_no_step_above_the_top_of_its_value_axis
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: "5" } ]))

    assert_equal %w[0 2 4 6], page.css("text.ks-bar-chart-text[data-axis-tick]").map(&:text)
  end

  def test_keeps_the_height_it_has_in_an_800px_wide_column_however_wide_it_is_drawn
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: "5" } ]))

    assert_equal %w[aspect-[5/2] max-h-80], page.css(".ks-bar-chart").first[:class].split & %w[aspect-[5/2] max-h-80]
  end

  def test_stretches_its_bars_across_whatever_width_it_is_drawn_at
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: "5" } ]))

    assert_equal "none", page.css("svg:has(rect.ks-bar-chart-bar)").first[:preserveAspectRatio]
  end

  def test_draws_every_bar_of_one_group_in_the_same_tone
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "v22", value: 2, group: "v22" }, { label: "", value: 3, group: "v22" } ]))

    assert_equal [ true, true ], page.css("rect.ks-bar-chart-bar").map { |bar| bar[:class].split.include?("ks-bar-chart-bar-group-5") }
  end

  def test_draws_each_group_in_a_tone_no_other_group_uses_from_the_oldest_to_the_newest
    bars = %w[v19 v21 v22].map { |version| { label: version, value: 2, group: version } }
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: bars))

    assert_equal %w[ks-bar-chart-bar-group-1 ks-bar-chart-bar-group-3 ks-bar-chart-bar-group-5], page.css("rect.ks-bar-chart-bar").map { |bar| bar[:class].split.last }
  end

  def test_draws_every_group_older_than_the_newest_four_in_the_oldest_tone
    bars = (1..7).map { |version| { label: "v#{version}", value: 2, group: version } }
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: bars))

    assert_equal %w[1 1 1 2 3 4 5], page.css("rect.ks-bar-chart-bar").map { |bar| bar[:class].split.last.delete_prefix("ks-bar-chart-bar-group-") }
  end

  def test_writes_a_label_under_only_the_first_bar_of_each_group
    bars = [ { label: "v19", value: 2, group: "v19" }, { label: "Tue", value: 3, group: "v19" }, { label: "v21", value: 4, group: "v21" } ]
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: bars))

    assert_equal %w[v19 v21], page.css("text.ks-bar-chart-text[data-bar-label]").map(&:text)
  end

  def test_starts_a_groups_label_at_the_left_edge_of_its_first_bar
    bars = %w[v19 v21 v22].map { |version| { label: version, value: 2, group: version } }
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: bars))
    label = page.css("text[data-bar-label]")[1]

    assert_equal [ page.css("rect.ks-bar-chart-bar")[1][:x] + "%", "start" ], [ label[:x], label[:"text-anchor"] ]
  end

  def test_draws_no_value_axis_as_a_strip
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: "5" } ], strip: true))

    assert_equal 0, page.css("[data-axis-tick]").size
  end

  def test_draws_only_a_baseline_and_no_grid_lines_as_a_strip
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: "5" } ], strip: true))

    assert_equal [ "100.0" ], page.css("line.ks-bar-chart-grid").map { |line| line[:y1] }
  end

  def test_keeps_a_short_fixed_height_as_a_strip
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: "5" } ], strip: true))

    assert_equal %w[h-[114px]], page.css(".ks-bar-chart").first[:class].split & %w[h-[114px] aspect-[5/2] max-h-80]
  end

  def test_draws_its_bars_nearly_touching_as_a_strip
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: [ { label: "Mon", value: "5" }, { label: "Tue", value: "3" } ], strip: true))

    assert_equal %w[46.0 46.0], page.css("rect.ks-bar-chart-bar").map { |bar| bar[:width] }
  end

  def test_ends_the_newest_groups_label_at_the_right_edge_of_the_chart
    bars = [ { label: "v19", value: 2, group: "v19" }, { label: "v21", value: 4, group: "v21" } ]
    page = render_inline(Keystone::Ui::BarChartComponent.new(bars: bars))
    label = page.css("text[data-bar-label]").last

    assert_equal [ "100.0%", "end" ], [ label[:x], label[:"text-anchor"] ]
  end
end
