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
end
