# frozen_string_literal: true

module Keystone
  module Ui
    class TimelineComponent < ViewComponent::Base
      TRACK_CLASSES = "ks-timeline-track relative w-full h-2 overflow-hidden"
      BAR_CLASSES = "ks-timeline-bar absolute inset-y-0"
      FAILED_CLASSES = "ks-timeline-failed"
      QUEUED_CLASSES = "ks-timeline-queued absolute inset-y-0"
      SCREEN_READER_CLASSES = "sr-only"
      SELECTED_ROW_CLASSES = "ks-table-row-current"
      ROW_TEXT_CLASSES = "ks-meter-label flex justify-between text-sm"
      AXIS_CLASSES = "ks-meter-label flex justify-between text-xs"
      ROW_STATUS_CLASSES = "flex items-center gap-2"
      MINIMUM_BAR_PERCENT = 2

      attr_reader :entries

      def initialize(entries:)
        entries.each { |entry| check_times(entry) }
        @entries = entries
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

      def running?(row)
        row[:tries].any? { |entry| entry[:ended_at].nil? }
      end

      def queued_style(entry)
        "left: #{percent(entry[:queued_at] - axis_start)}%; width: #{percent(entry[:started_at] - entry[:queued_at])}%"
      end

      def bar_classes(entry)
        [ BAR_CLASSES, (FAILED_CLASSES if entry[:failed]) ].compact.join(" ")
      end

      def bar_tag(entry)
        entry[:href] ? :a : :div
      end

      def duration(row)
        written_duration(ended_at(row[:tries].last) - row[:tries].first[:started_at])
      end

      def total_duration
        written_duration(axis_end - axis_start)
      end

      def axis_start_label
        written_duration(0)
      end

      private

      def check_times(entry)
        raise ArgumentError, "Timeline entry #{entry[:label].inspect} has no started_at" unless entry[:started_at]
        raise ArgumentError, "Timeline entry #{entry[:label].inspect} ends before it starts" if entry[:ended_at] && entry[:ended_at] < entry[:started_at]
      end

      def written_duration(seconds)
        hours, rest = seconds.round.divmod(3600)
        minutes, seconds = rest.divmod(60)
        parts = [ [ hours, "h" ], [ minutes, "m" ], [ seconds, "s" ] ].drop_while { |amount, _| amount.zero? }
        parts = [ [ 0, "s" ] ] if parts.empty?
        parts.map { |amount, unit| "#{amount}#{unit}" }.join(" ")
      end

      def axis_start
        @axis_start ||= entries.map { |entry| entry[:queued_at] || entry[:started_at] }.min
      end

      def axis_end
        @axis_end ||= entries.map { |entry| entry[:ended_at] || entry[:started_at] }.max
      end

      def ended_at(entry)
        entry[:ended_at] || axis_end
      end

      def bar_width(entry)
        format("%g", [ share(ended_at(entry) - entry[:started_at]), MINIMUM_BAR_PERCENT ].max)
      end

      def percent(seconds)
        format("%g", share(seconds))
      end

      def share(seconds)
        span = axis_end - axis_start
        span.zero? ? 0 : (seconds / span * 100).round(2)
      end
    end
  end
end
