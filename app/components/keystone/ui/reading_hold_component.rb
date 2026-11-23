# frozen_string_literal: true

require "securerandom"

module Keystone
  module Ui
    class ReadingHoldComponent < ViewComponent::Base
      STATUS_CLASSES = "ks-reading-hold-status text-sm"
      ANNOUNCER_CLASSES = "sr-only"

      renders_one :action

      def initialize(seconds: 0, elapsed: 0, require_end: false, waiting: "Available in {seconds} seconds", end_waiting: "Read to the end to continue", ready: "Now available", field_prefix: "reading")
        @seconds = seconds
        @elapsed = elapsed
        @require_end = require_end
        @waiting = waiting
        @end_waiting = end_waiting
        @ready = ready
        @field_prefix = field_prefix
      end

      def end_reached_field
        "#{@field_prefix}[end_reached]"
      end

      def in_view_on_load_field
        "#{@field_prefix}[end_in_view_on_load]"
      end

      def status_id
        @status_id ||= "reading-hold-status-#{SecureRandom.hex(4)}"
      end

      def button_options
        {data: {reading_hold_target: "button"}, aria: {describedby: status_id}}
      end

      def wrapper_data
        {
          controller: "reading-hold",
          action: "turbo:before-cache@document->reading-hold#holdForCache pageshow@window->reading-hold#restore",
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
