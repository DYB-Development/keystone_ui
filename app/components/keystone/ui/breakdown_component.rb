# frozen_string_literal: true

module Keystone
  module Ui
    class BreakdownComponent < ViewComponent::Base
      LINE_CLASSES = "ks-breakdown-line flex gap-2"
      AMOUNT_CLASSES = "ks-breakdown-amount w-24 shrink-0 text-right tabular-nums"
      LABEL_CLASSES = "ks-breakdown-label"

      attr_reader :lines

      def initialize(lines:, total:)
        @lines = lines
        @total = total
      end
    end
  end
end
