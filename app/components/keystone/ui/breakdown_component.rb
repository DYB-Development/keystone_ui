# frozen_string_literal: true

module Keystone
  module Ui
    class BreakdownComponent < ViewComponent::Base
      LINE_CLASSES = "ks-breakdown-line flex gap-2"
      AMOUNT_CLASSES = "ks-breakdown-amount w-24 shrink-0 text-right tabular-nums"
      LABEL_CLASSES = "ks-breakdown-label"
      TOTAL_CLASSES = "ks-breakdown-total ks-stat-card-emphasis flex gap-2 border-t"

      attr_reader :lines, :total

      def initialize(lines:, total:)
        @lines = lines
        @total = total
      end
    end
  end
end
