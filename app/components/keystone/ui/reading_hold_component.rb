# frozen_string_literal: true

module Keystone
  module Ui
    class ReadingHoldComponent < ViewComponent::Base
      def initialize(seconds: 0, elapsed: 0, require_end: false)
        @seconds = seconds
        @elapsed = elapsed
        @require_end = require_end
      end

      def wrapper_data
        {
          controller: "reading-hold",
          reading_hold_seconds_value: @seconds,
          reading_hold_elapsed_value: @elapsed,
          reading_hold_require_end_value: @require_end
        }
      end
    end
  end
end
