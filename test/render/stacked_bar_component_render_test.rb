# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::StackedBarComponentRenderTest < ViewComponent::TestCase
  def test_draws_one_segment_for_each_amount
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "Our gross profit", amount: 1800, tone: :orange }, { label: "COGS", amount: 600, tone: :blue } ]))

    assert_equal 2, page.css(".ks-stacked-bar > .ks-stacked-bar-segment").size
  end

  def test_leaves_out_a_segment_whose_amount_is_zero_or_negative
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "Customer net value", amount: -300, tone: :teal }, { label: "Our gross profit", amount: 0, tone: :orange }, { label: "COGS", amount: 600, tone: :blue } ]))

    assert_equal 1, page.css(".ks-stacked-bar > .ks-stacked-bar-segment").size
  end

  def test_gives_each_segment_a_share_of_the_bar_in_proportion_to_its_amount
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "Our gross profit", amount: 1800, tone: :orange }, { label: "COGS", amount: 600, tone: :blue } ]))

    assert_equal [ "flex: 1800 1 0%", "flex: 600 1 0%" ], page.css(".ks-stacked-bar-segment").map { |segment| segment["style"] }
  end

  def test_draws_a_segment_given_a_size_at_that_size_in_place_of_its_amount
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "Customer net value", amount: 1200, size: 900, tone: :teal } ]))

    assert_equal "flex: 900 1 0%", page.at_css(".ks-stacked-bar-segment")&.[]("style")
  end

  def test_fills_each_segment_with_the_colour_of_its_tone
    tones = %i[teal orange blue amber]
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: tones.map { |tone| { label: tone.to_s, amount: 100, tone: tone } }))

    assert_equal %w[ks-fill-teal ks-fill-orange ks-fill-blue ks-fill-amber], page.css(".ks-stacked-bar-segment").map { |segment| segment["class"].split.grep(/\Aks-fill-/).first }
  end

  def test_refuses_a_tone_it_does_not_know_naming_it
    error = assert_raises(ArgumentError) { Keystone::Ui::StackedBarComponent.new(segments: [ { label: "COGS", amount: 600, tone: :purple } ]) }

    assert_match(/purple/, error.message)
  end

  def test_prints_each_segments_formatted_amount_inside_it
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "Our gross profit", amount: 1800, value: "$1,800", tone: :orange } ]))

    assert_equal "$1,800", page.at_css(".ks-stacked-bar-segment > .ks-stacked-bar-amount")&.text
  end

  def test_hides_a_segments_amount_when_the_segment_is_too_narrow_to_hold_it
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "Our gross profit", amount: 1800, value: "$1,800", tone: :orange } ]))

    assert_equal [ true, true ], [ page.at_css(".ks-stacked-bar-segment")["class"].split.include?("@container"), page.at_css(".ks-stacked-bar-amount")["class"].split.include?("@max-[8ch]:hidden") ]
  end

  def test_a_segments_tooltip_shows_its_name_amount_and_share_of_the_bar
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "Our gross profit", amount: 1800, value: "$1,800", tone: :orange }, { label: "COGS", amount: 600, value: "$600", tone: :blue } ]))

    assert_equal [ "Our gross profit", "$1,800", "75% of the total" ], page.css(".ks-stacked-bar-segment").first.css(".ks-stacked-bar-tip > span").map(&:text)
  end

  def test_a_bar_given_a_total_and_its_name_gives_each_share_of_that_total
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "Our gross profit", amount: 1800, value: "$1,800", tone: :orange } ], total: 3000, total_label: "actual value"))

    assert_equal "60% of actual value", page.css(".ks-stacked-bar-tip > span").last&.text
  end

  def test_a_bar_given_a_total_of_zero_gives_no_share
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "COGS", amount: 600, value: "$600", tone: :blue } ], total: 0, total_label: "actual value"))

    assert_equal "– of actual value", page.css(".ks-stacked-bar-tip > span").last&.text
  end

  def test_a_segment_can_be_reached_with_the_keyboard
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "COGS", amount: 600, tone: :blue } ]))

    assert_equal "0", page.at_css(".ks-stacked-bar-segment")&.[]("tabindex")
  end

  def test_a_segments_tooltip_shows_only_while_the_segment_is_hovered_or_focused
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "COGS", amount: 600, tone: :blue } ]))
    segment = page.at_css(".ks-stacked-bar-segment")

    assert_equal [ true, %w[hidden group-hover:block group-focus:block] ], [ segment["class"].split.include?("group"), segment.at_css(".ks-stacked-bar-tip")["class"].split & %w[hidden group-hover:block group-focus:block] ]
  end

  def test_a_tooltip_near_either_end_of_the_bar_stays_inside_the_bar
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "Customer net value", amount: 100, tone: :teal }, { label: "Our gross profit", amount: 800, tone: :orange }, { label: "COGS", amount: 100, tone: :blue } ]))

    assert_equal [ %w[left-0], %w[left-1/2 -translate-x-1/2], %w[right-0] ], page.css(".ks-stacked-bar-tip").map { |tip| tip["class"].split & %w[left-0 left-1/2 -translate-x-1/2 right-0] }
  end

  def test_a_screen_reader_hears_each_segments_name_amount_and_share_once
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "Our gross profit", amount: 1800, value: "$1,800", tone: :orange }, { label: "COGS", amount: 600, value: "$600", tone: :blue } ]))
    segment = page.at_css(".ks-stacked-bar-segment")

    assert_equal [ "img", "Our gross profit $1,800, 75% of the total", "true", "true" ], [ segment["role"], segment["aria-label"], segment.at_css(".ks-stacked-bar-amount")["aria-hidden"], segment.at_css(".ks-stacked-bar-tip")["aria-hidden"] ]
  end

  def test_lists_every_segment_under_the_bar_by_name_and_amount_including_one_not_drawn
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "Customer net value", amount: -300, value: "-$300", tone: :teal }, { label: "COGS", amount: 600, value: "$600", tone: :blue } ]))

    assert_equal [ [ "Customer net value", "-$300" ], [ "COGS", "$600" ] ], page.css(".ks-stacked-bar + .ks-stacked-bar-legend > li").map { |item| item.css("span:not(.ks-stacked-bar-swatch)").map(&:text) }
  end

  def test_starts_each_legend_entry_with_a_swatch_in_its_segments_colour
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "Our gross profit", amount: 1800, tone: :orange }, { label: "CAC", amount: 400, tone: :amber } ]))

    assert_equal %w[ks-fill-orange ks-fill-amber], page.css(".ks-stacked-bar-legend > li > .ks-stacked-bar-swatch:first-child").map { |swatch| swatch["class"].split.grep(/\Aks-fill-/).first }
  end

  def test_draws_the_bar_twenty_eight_pixels_tall
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "COGS", amount: 600, tone: :blue } ]))

    assert_includes page.at_css(".ks-stacked-bar")["class"].split, "h-7"
  end

  def test_a_bar_given_its_legend_above_lists_the_segments_before_the_bar
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "COGS", amount: 600, tone: :blue } ], legend: :above))

    assert_equal %w[ul div], page.at_css("div").element_children.map(&:name)
  end

  def test_a_legend_above_the_bar_carries_the_spacing_for_sitting_above_it
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "COGS", amount: 600, tone: :blue } ], legend: :above))

    assert_includes page.at_css("ul")["class"].split, "ks-stacked-bar-legend-above"
  end
end
