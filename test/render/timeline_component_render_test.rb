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

  def test_places_each_bar_by_its_start_and_end_on_one_axis_from_the_earliest_start_to_the_latest_end
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: entries))

    assert_equal [ "left: 0%; width: 25%", "left: 25%; width: 75%" ], page.css("[data-timeline-row] [data-timeline-bar]").map { |bar| bar[:style] }
  end

  def test_writes_each_rows_duration_in_minutes_and_seconds
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: entries))

    assert_equal [ "1m 0s", "3m 0s" ], page.css("[data-timeline-row] [data-timeline-duration]").map(&:text)
  end

  def test_writes_a_duration_of_an_hour_or_more_in_hours_minutes_and_seconds
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: [ { label: "Run", started_at: START, ended_at: START + 3605 } ]))

    assert_equal "1h 0m 5s", page.at_css("[data-timeline-duration]").text
  end

  def test_marks_the_axis_with_zero_at_its_left_and_the_total_duration_at_its_right
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: entries))

    assert_equal [ "0s", "4m 0s" ], [ page.at_css("[data-timeline-axis-start]")&.text, page.at_css("[data-timeline-axis-end]")&.text ]
  end

  def test_draws_each_rows_track_in_the_progress_tracks_look
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: entries))

    assert_equal 2, page.css("[data-timeline-row] .ks-progress-track").size
  end
end
