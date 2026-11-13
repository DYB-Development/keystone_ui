# frozen_string_literal: true

module Keystone
  module Ui
    class TimelineComponent < ViewComponent::Base
      attr_reader :entries

      def initialize(entries:)
        @entries = entries
      end

      def bar_style(entry)
        "left: #{percent(entry[:started_at] - axis_start)}%; width: #{percent(entry[:ended_at] - entry[:started_at])}%"
      end

      private

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
