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

  def linked
    [
      { label: "Plan", started_at: START, ended_at: START + 60, href: "/steps/plan" },
      { label: "Build", started_at: START + 60, ended_at: START + 120, failed: true, href: "/steps/build-1" },
      { label: "Build", started_at: START + 120, ended_at: START + 240, href: "/steps/build-2" }
    ]
  end

  def test_draws_an_entry_given_an_address_as_a_bar_that_opens_it
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: linked))

    assert_equal [ "/steps/plan", "/steps/build-1", "/steps/build-2" ], page.css("a[data-timeline-bar]").map { |bar| bar[:href] }
  end

  def test_names_a_linked_bar_for_screen_readers_by_its_rows_label
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: linked))

    assert_equal [ [ "Plan" ], [ "Build", "Failed" ], [ "Build" ] ], page.css("a[data-timeline-bar]").map { |bar| bar.css(".sr-only").map(&:text) }
  end

  def test_links_a_rows_label_to_the_address_of_its_last_entry_that_has_one
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: linked + [ { label: "Build", started_at: START + 240, ended_at: START + 300 } ]))

    assert_equal [ "/steps/plan", "/steps/build-2" ], page.css("a[data-timeline-label]").map { |label| label[:href] }
  end

  def selected
    [ retried[0], retried[1].merge(selected: true), retried[2] ]
  end

  def test_tells_screen_readers_the_row_of_the_selected_entry_is_the_current_item
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: selected))

    assert_equal [ nil, "true" ], page.css("[data-timeline-row]").map { |row| row["aria-current"] }
  end

  def test_draws_the_row_of_the_selected_entry_as_the_current_row
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: selected))

    assert_equal [ false, true ], page.css("[data-timeline-row]").map { |row| row[:class].to_s.split.include?("ks-table-row-current") }
  end

  def test_draws_no_links_for_entries_given_no_address
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: retried))

    assert_empty page.css("a")
  end

  def test_refuses_an_entry_with_no_start_time_naming_its_label
    error = assert_raises(ArgumentError) { Keystone::Ui::TimelineComponent.new(entries: [ { label: "Build", started_at: nil, ended_at: START } ]) }

    assert_includes error.message, "Build"
  end

  def test_refuses_an_entry_that_ends_before_it_starts_naming_its_label
    error = assert_raises(ArgumentError) { Keystone::Ui::TimelineComponent.new(entries: [ { label: "Deploy", started_at: START + 60, ended_at: START } ]) }

    assert_includes error.message, "Deploy"
  end

  def running
    [
      { label: "Plan", started_at: START, ended_at: START + 240 },
      { label: "Build", started_at: START + 60, ended_at: nil }
    ]
  end

  def test_draws_an_entry_with_no_end_time_up_to_the_latest_time_on_the_axis
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: running))

    assert_equal "left: 25%; width: 75%", page.css("[data-timeline-bar]").last[:style]
  end

  def test_marks_the_row_of_an_entry_with_no_end_time_as_running
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: running))

    assert_equal [ nil, "Running" ], page.css("[data-timeline-row]").map { |row| row.at_css(".ks-status-dot.ks-status-dot-info")&.text }
  end

  def test_draws_each_bar_at_a_small_visible_width_when_every_entry_starts_and_ends_at_the_same_moment
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: [
      { label: "Plan", started_at: START, ended_at: START },
      { label: "Build", started_at: START, ended_at: START }
    ]))

    assert_equal [ "left: 0%; width: 2%", "left: 0%; width: 2%" ], page.css("[data-timeline-bar]").map { |bar| bar[:style] }
  end

  def test_shows_a_message_saying_there_are_no_steps_when_given_no_entries
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: []))

    assert_equal "No steps", page.at_css(".ks-empty-state")&.text&.strip
  end

  def test_draws_each_row_of_a_one_line_timeline_as_its_label_then_its_bar_then_its_duration
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: entries, one_line: true))

    assert_equal [ [ "label", "track", "duration" ] ] * 2, page.css("[data-timeline-row]").map { |row| row.element_children.map { |part| part_name(part) } }
  end

  def test_lays_a_one_line_timeline_out_from_sm_up_in_a_label_column_a_bar_column_and_a_duration_column
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: entries, one_line: true))

    assert_includes page.at_css("[data-timeline]")[:class].to_s.split, "sm:grid-cols-[fit-content(40%)_1fr_auto]"
  end

  def test_gives_every_row_of_a_one_line_timeline_the_timelines_own_columns_so_their_bars_share_one_width
    page = render_inline(Keystone::Ui::TimelineComponent.new(entries: entries, one_line: true))

    assert_equal [ true, true ], page.css("[data-timeline-row]").map { |row| row[:class].to_s.split.include?("sm:grid-cols-subgrid") }
  end

  def part_name(part)
    return "duration" if part.at_css("[data-timeline-duration]")
    return "label" if part.key?("data-timeline-label")
    return "track" if part[:class].to_s.split.include?("ks-timeline-track")

    part.name
  end
end
