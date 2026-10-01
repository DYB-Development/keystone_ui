# frozen_string_literal: true

module Keystone
  module Ui
    class BreakdownComponent < ViewComponent::Base
      LINE_CLASSES = "ks-breakdown-line"
      AMOUNT_CLASSES = "ks-breakdown-amount"
      LABEL_CLASSES = "ks-breakdown-label"
      BREAKDOWN_CLASSES = "ks-breakdown"
      TOTAL_CLASSES = "ks-breakdown-total"
      SUM_CLASSES = "ks-breakdown-sum"

      attr_reader :lines, :total

      def initialize(lines:, total:)
        @lines = lines
        @total = total
      end
    end
  end
end
