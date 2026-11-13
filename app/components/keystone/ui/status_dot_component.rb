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

      def initialize(state:, label:)
        @state = state
        @label = label
      end

      def call
        tag.span(class: "ks-status-dot #{STATE_CLASSES[@state]}")
      end
    end
  end
end
