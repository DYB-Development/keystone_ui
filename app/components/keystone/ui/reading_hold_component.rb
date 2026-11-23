# frozen_string_literal: true

module Keystone
  module Ui
    class ReadingHoldComponent < ViewComponent::Base
      def initialize(seconds: 0, elapsed: 0, require_end: false, waiting: "Available in {seconds} seconds", end_waiting: "Read to the end to continue", ready: "Now available")
        @seconds = seconds
        @elapsed = elapsed
        @require_end = require_end
        @waiting = waiting
        @end_waiting = end_waiting
        @ready = ready
      end

      def wrapper_data
        {
          controller: "reading-hold",
          reading_hold_seconds_value: @seconds,
          reading_hold_elapsed_value: @elapsed,
          reading_hold_require_end_value: @require_end,
          reading_hold_waiting_value: @waiting,
          reading_hold_end_waiting_value: @end_waiting,
          reading_hold_ready_value: @ready
        }
      end
    end
  end
end
