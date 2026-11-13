# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::TimelineComponentRenderTest < ViewComponent::TestCase
  START = Time.utc(2026, 11, 13, 9, 0, 0)

  def entries
    [
      { label: "Plan", started_at: START, ended_at: START + 60 },
      { label: "Build", started_at: START + 60, ended_at: START + 240 }
    ]
  end

  def test_draws_one_row_per_entry_labelled_in_the_order_given
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: entries))

    assert_equal %w[Plan Build], page.css("[data-timeline-row] [data-timeline-label]").map(&:text)
  end
end
