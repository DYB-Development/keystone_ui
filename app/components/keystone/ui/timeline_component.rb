# frozen_string_literal: true

module Keystone
  module Ui
    class TimelineComponent < ViewComponent::Base
      TRACK_CLASSES = "ks-progress-track relative w-full h-2 overflow-hidden"
      BAR_CLASSES = "ks-progress-bar absolute inset-y-0"
      FAILED_CLASSES = "ks-timeline-failed"
      SCREEN_READER_CLASSES = "sr-only"
      ROW_TEXT_CLASSES = "ks-meter-label flex justify-between text-sm"
      AXIS_CLASSES = "ks-meter-label flex justify-between text-xs"

      attr_reader :entries

      def initialize(entries:)
        @entries = entries
      end

      def bar_style(entry)
        "left: #{percent(entry[:started_at] - axis_start)}%; width: #{percent(entry[:ended_at] - entry[:started_at])}%"
      end

      def rows
        entries.group_by { |entry| entry[:label] }.map { |label, tries| { label: label, tries: tries } }
      end

      def bar_classes(entry)
        [ BAR_CLASSES, (FAILED_CLASSES if entry[:failed]) ].compact.join(" ")
      end

      def duration(row)
        written_duration(row[:tries].last[:ended_at] - row[:tries].first[:started_at])
      end

      def total_duration
        written_duration(axis_end - axis_start)
      end

      def axis_start_label
        written_duration(0)
      end

      private

      def written_duration(seconds)
        hours, rest = seconds.round.divmod(3600)
        minutes, seconds = rest.divmod(60)
        parts = [ [ hours, "h" ], [ minutes, "m" ], [ seconds, "s" ] ].drop_while { |amount, _| amount.zero? }
        parts = [ [ 0, "s" ] ] if parts.empty?
        parts.map { |amount, unit| "#{amount}#{unit}" }.join(" ")
      end

      def axis_start
        @axis_start ||= entries.map { |entry| entry[:started_at] }.min
      end

      def axis_end
        @axis_end ||= entries.map { |entry| entry[:ended_at] }.max
      end

      def percent(seconds)
        format("%g", (seconds / (axis_end - axis_start) * 100).round(2))
      end
    end
  end
end
