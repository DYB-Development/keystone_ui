# frozen_string_literal: true

module Keystone
  module Ui
    class BreakdownComponent < ViewComponent::Base
      LINE_CLASSES = "ks-breakdown-line block"
      AMOUNT_CLASSES = "ks-breakdown-amount inline-block w-24 text-right tabular-nums"
      LABEL_CLASSES = "ks-breakdown-label"
      TOTAL_CLASSES = "ks-breakdown-total ks-stat-card-emphasis block"

      attr_reader :lines, :total

      def initialize(lines:, total:)
        @lines = lines
        @total = total
      end
    end
  end
end
