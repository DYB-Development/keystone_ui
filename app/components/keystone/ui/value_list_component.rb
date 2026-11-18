# frozen_string_literal: true

module Keystone
  module Ui
    class ValueListComponent < ViewComponent::Base
      ALIGN_CLASSES = { start: nil, end: "ks-value-list-end" }.freeze
      RIGHT_MARK_CLASSES = "ks-tone-success inline size-5 align-text-bottom"
      COLUMNS_CLASSES = "grid grid-cols-1 sm:grid-cols-2 ks-grid-gap-sm"
      PAIR_CLASSES = "flex flex-col min-w-0"
      PAIR_LABEL_CLASSES = "ks-value-list-label basis-auto text-xs"
      CAPS_LABEL_CLASSES = "ks-label-caps"
      VALUE_CLASSES = "ks-value-list-value"
      MONO_VALUE_CLASSES = "ks-value-list-value font-mono"

      attr_reader :rows

      def initialize(rows:, align: :start, columns: false, label_caps: false, value_mono: false)
        @rows = rows
        @value_mono = value_mono
        @label_caps = label_caps
        @align = align
        @columns = columns
      end

      def classes
        [ "ks-value-list", ALIGN_CLASSES.fetch(@align), (COLUMNS_CLASSES if @columns) ].compact.join(" ")
      end

      def shown_value(row)
        row[:value].to_s.empty? ? row[:fallback] : row[:value]
      end

      def right_mark_classes
        RIGHT_MARK_CLASSES
      end

      def label_classes
        [ @columns ? PAIR_LABEL_CLASSES : "ks-value-list-label", (CAPS_LABEL_CLASSES if @label_caps) ].compact.join(" ")
      end

      def value_classes
        @value_mono ? MONO_VALUE_CLASSES : VALUE_CLASSES
      end

      def row_classes(row)
        [ @columns ? PAIR_CLASSES : "ks-value-list-row", ("ks-value-list-total" if row[:total]) ].compact.join(" ")
      end
    end
  end
end
