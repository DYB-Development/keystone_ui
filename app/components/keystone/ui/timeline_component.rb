# frozen_string_literal: true

module Keystone
  module Ui
    class TimelineComponent < ViewComponent::Base
      TRACK_CLASSES = "ks-timeline-track relative w-full h-2 overflow-hidden"
      BAR_CLASSES = "ks-timeline-bar absolute inset-y-0"
      FAILED_CLASSES = "ks-timeline-failed"
      WAITING_CLASSES = "ks-tone-warning"
      QUEUED_CLASSES = "ks-timeline-queued absolute inset-y-0"
      WAITING_BAR_CLASSES = "ks-timeline-waiting absolute inset-y-0"
      SCREEN_READER_CLASSES = "sr-only"
      SELECTED_ROW_CLASSES = "ks-table-row-current"
      TIMELINE_CLASSES = "flex flex-col ks-grid-gap-sm"
      ONE_LINE_TIMELINE_CLASSES = "sm:grid sm:grid-cols-[fit-content(40%)_1fr_auto]"
      ONE_LINE_ROW_CLASSES = "grid grid-cols-[1fr_auto] items-center ks-grid-gap-x-sm text-sm sm:col-span-3 sm:grid-cols-subgrid"
      ONE_LINE_LABEL_CLASSES = "ks-meter-label min-w-0 wrap-break-word sm:truncate sm:mb-0"
      ONE_LINE_TRACK_CLASSES = "col-span-2 row-start-2 sm:col-span-1 sm:col-start-2 sm:row-start-1"
      ONE_LINE_STATUS_CLASSES = "ks-meter-label justify-self-end sm:mb-0"
      ROW_TEXT_CLASSES = "ks-meter-label flex justify-between text-sm"
      AXIS_CLASSES = "ks-meter-label flex justify-between text-xs"
      ROW_STATUS_CLASSES = "flex items-center ks-grid-gap-sm"
      PHONE_AXIS_CLASSES = "ks-meter-label flex justify-between text-xs sm:col-span-3 sm:hidden"
      ONE_LINE_AXIS_CLASSES = "ks-meter-label relative h-4 text-xs sm:col-start-2 max-sm:hidden"
      MARK_CLASSES = "absolute top-0 whitespace-nowrap"
      MINIMUM_BAR_PERCENT = 2
      MARK_STEPS = [ 1, 2, 5, 10, 15, 30, 60, 120, 300, 600, 900, 1800, 3600, 7200, 10_800, 21_600, 43_200, 86_400 ].freeze
      MAXIMUM_MARK_INTERVALS = 6

      attr_reader :entries, :one_line

      def initialize(entries:, one_line: false)
        entries.each { |entry| check_times(entry) }
        @entries = entries
        @one_line = one_line
      end

      def track_classes
        [ TRACK_CLASSES, (ONE_LINE_TRACK_CLASSES if one_line) ].compact.join(" ")
      end

      def axis_classes
        one_line ? PHONE_AXIS_CLASSES : AXIS_CLASSES
      end

      def label_classes
        ONE_LINE_LABEL_CLASSES if one_line
      end

      def status_classes
        [ ROW_STATUS_CLASSES, (ONE_LINE_STATUS_CLASSES if one_line) ].compact.join(" ")
      end

      def bar_style(entry)
        "left: #{percent(entry[:started_at] - axis_start)}%; width: #{bar_width(entry)}%"
      end

      def rows
        entries.group_by { |entry| entry[:label] }.map { |label, tries| { label: label, tries: tries } }
      end

      def row_href(row)
        row[:tries].filter_map { |entry| entry[:href] }.last
      end

      def selected?(row)
        row[:tries].any? { |entry| entry[:selected] }
      end

      def timeline_classes
        [ TIMELINE_CLASSES, (ONE_LINE_TIMELINE_CLASSES if one_line) ].compact.join(" ")
      end

      def row_classes(row)
        [ (ONE_LINE_ROW_CLASSES if one_line), (SELECTED_ROW_CLASSES if selected?(row)) ].compact.join(" ").presence
      end

      def running?(row)
        !waiting?(row) && row[:tries].any? { |entry| entry[:ended_at].nil? }
      end

      def queued_style(entry)
        "left: #{percent(entry[:queued_at] - axis_start)}%; width: #{percent(entry[:started_at] - entry[:queued_at])}%"
      end

      def bar_classes(entry)
        return WAITING_BAR_CLASSES if entry[:waiting]

        [ BAR_CLASSES, (FAILED_CLASSES if entry[:failed]) ].compact.join(" ")
      end

      def bar_tag(entry)
        entry[:href] ? :a : :div
      end

      def waiting?(row)
        row[:tries].any? { |entry| entry[:waiting] }
      end

      def duration_classes(row)
        WAITING_CLASSES if waiting?(row)
      end

      def duration(row)
        return "waiting" if waiting?(row)

        [ written_duration(row[:tries].sum { |entry| ended_at(entry) - entry[:started_at] }), attempts(row) ].compact.join(" · ")
      end

      def total_duration
        written_duration(axis_end - axis_start)
      end

      def marks
        (0..mark_intervals).map { |index| { label: written_mark(index * mark_step), style: mark_style(index) } }
      end

      def axis_end_label
        one_line ? written_mark(scale) : total_duration
      end

      def axis_start_label
        written_mark(0)
      end

      private

      def attempts(row)
        "#{row[:tries].size} att." if row[:tries].size > 1
      end

      def check_times(entry)
        raise ArgumentError, "Timeline entry #{entry[:label].inspect} has no started_at" unless entry[:started_at]
        raise ArgumentError, "Timeline entry #{entry[:label].inspect} ends before it starts" if entry[:ended_at] && entry[:ended_at] < entry[:started_at]
      end

      def written_duration(seconds)
        return format("%.1fs", seconds.round(1)) if seconds.round(1) < 10

        hours, rest = seconds.round.divmod(3600)
        minutes, seconds = rest.divmod(60)
        parts = [ [ hours, "h" ], [ minutes, "m" ], [ seconds, "s" ] ].drop_while { |amount, _| amount.zero? }
        parts.map { |amount, unit| "#{amount}#{unit}" }.join(" ")
      end

      def written_mark(seconds)
        hours, rest = seconds.divmod(3600)
        minutes, seconds = rest.divmod(60)
        parts = [ [ hours, "h" ], [ minutes, "m" ], [ seconds, "s" ] ].reject { |amount, _| amount.zero? }
        parts.empty? ? "0s" : parts.map { |amount, unit| "#{amount}#{unit}" }.join(" ")
      end

      def mark_style(index)
        return "left: 0%" if index.zero?
        return "right: 0%" if index == mark_intervals

        "left: #{percent(index * mark_step)}%; transform: translateX(-50%)"
      end

      def mark_step
        @mark_step ||= MARK_STEPS.find { |step| span <= step * MAXIMUM_MARK_INTERVALS } || (span / (MARK_STEPS.last * MAXIMUM_MARK_INTERVALS)).ceil * MARK_STEPS.last
      end

      def mark_intervals
        [ (span / mark_step).ceil, 1 ].max
      end

      def scale
        one_line ? mark_intervals * mark_step : span
      end

      def span
        axis_end - axis_start
      end

      def axis_start
        @axis_start ||= entries.map { |entry| entry[:queued_at] || entry[:started_at] }.min
      end

      def axis_end
        @axis_end ||= entries.map { |entry| entry[:ended_at] || entry[:started_at] }.max
      end

      def ended_at(entry)
        return axis_start + scale if entry[:waiting]

        entry[:ended_at] || axis_end
      end

      def bar_width(entry)
        format("%g", [ share(ended_at(entry) - entry[:started_at]), MINIMUM_BAR_PERCENT ].max)
      end

      def percent(seconds)
        format("%g", share(seconds))
      end

      def share(seconds)
        scale.zero? ? 0 : (seconds.fdiv(scale) * 100).round(2)
      end
    end
  end
end
