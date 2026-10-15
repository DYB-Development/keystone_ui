# frozen_string_literal: true

module Keystone
  module Ui
    class ValueListComponent < ViewComponent::Base
      ALIGN_CLASSES = { start: nil, end: "ks-value-list-end" }.freeze

      attr_reader :rows

      def initialize(rows:, align: :start)
        @rows = rows
        @align = align
      end

      def classes
        [ "ks-value-list", ALIGN_CLASSES.fetch(@align) ].compact.join(" ")
      end

      def shown_value(row)
        row[:value].to_s.empty? ? row[:fallback] : row[:value]
      end

      def row_classes(row)
        [ "ks-value-list-row", ("ks-value-list-total" if row[:total]) ].compact.join(" ")
      end
    end
  end
end
