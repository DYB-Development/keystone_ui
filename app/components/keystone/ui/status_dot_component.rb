# frozen_string_literal: true

module Keystone
  module Ui
    class StatusDotComponent < ViewComponent::Base
      STATE_CLASSES = {
        neutral: "ks-status-dot-neutral",
        success: "ks-status-dot-success",
        danger: "ks-status-dot-danger",
        warning: "ks-status-dot-warning",
        info: "ks-status-dot-info"
      }.freeze

      LABEL_CLASSES = "sr-only"

      def initialize(state:, label:)
        raise ArgumentError, "Unknown status dot state #{state.inspect}, expected one of #{STATE_CLASSES.keys.join(', ')}" unless STATE_CLASSES.key?(state)

        @state = state
        @label = label
      end

      def call
        tag.span(class: "ks-status-dot #{STATE_CLASSES[@state]}") { tag.span(@label, class: LABEL_CLASSES) }
      end
    end
  end
end
