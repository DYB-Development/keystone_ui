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

  def test_draws_each_rows_track_in_the_timelines_own_colour
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: entries))

    assert_equal 2, page.css("[data-timeline-row] .ks-timeline-track").size
  end

  def test_draws_each_bar_in_the_timelines_own_colour
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: entries))

    assert_equal 2, page.css("[data-timeline-bar].ks-timeline-bar").size
  end

  def retried
    [
      { label: "Plan", started_at: START, ended_at: START + 60 },
      { label: "Build", started_at: START + 60, ended_at: START + 120, failed: true },
      { label: "Build", started_at: START + 120, ended_at: START + 240 }
    ]
  end

  def test_draws_entries_that_share_a_label_on_one_row_with_one_bar_per_entry
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: retried))

    assert_equal [ [ "Plan", 1 ], [ "Build", 2 ] ], page.css("[data-timeline-row]").map { |row| [ row.at_css("[data-timeline-label]").text, row.css("[data-timeline-bar]").size ] }
  end

  def test_orders_rows_by_where_their_label_first_appears
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: [ retried[1], retried[0], retried[2] ]))

    assert_equal %w[Build Plan], page.css("[data-timeline-row] [data-timeline-label]").map(&:text)
  end

  def test_gives_a_row_of_several_entries_the_duration_from_its_first_start_to_its_last_end
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: retried))

    assert_equal [ "1m 0s", "3m 0s" ], page.css("[data-timeline-row] [data-timeline-duration]").map(&:text)
  end

  def test_draws_a_failed_entrys_bar_in_red
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: retried))

    assert_equal [ false, true, false ], page.css("[data-timeline-bar]").map { |bar| bar[:class].split.include?("ks-timeline-failed") }
  end

  def test_tells_screen_readers_that_a_failed_entry_failed
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: retried))

    assert_equal [ "", "Failed", "" ], page.css("[data-timeline-bar]").map { |bar| bar.at_css(".sr-only")&.text.to_s }
  end

  def test_draws_the_time_an_entry_spent_queued_before_its_bar_in_its_own_colour
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: [
      { label: "Plan", started_at: START, ended_at: START + 60 },
      { label: "Build", queued_at: START + 60, started_at: START + 120, ended_at: START + 240 }
    ]))

    assert_equal [ "left: 25%; width: 25%" ], page.css("[data-timeline-queued].ks-timeline-queued").map { |segment| segment[:style] }
  end

  def test_starts_the_axis_at_the_earliest_queued_time
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: [ { label: "Build", queued_at: START, started_at: START + 60, ended_at: START + 240 } ]))

    assert_equal "left: 25%; width: 75%", page.at_css("[data-timeline-bar]")[:style]
  end
end
