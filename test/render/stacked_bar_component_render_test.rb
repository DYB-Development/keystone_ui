# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::StackedBarComponentRenderTest < ViewComponent::TestCase
  def test_draws_one_segment_for_each_amount
    page = render_inline(Keystone::Ui::StackedBarComponent.new(segments: [ { label: "Our gross profit", amount: 1800, tone: :orange }, { label: "COGS", amount: 600, tone: :blue } ]))

    assert_equal 2, page.css(".ks-stacked-bar > .ks-stacked-bar-segment").size
  end
end
