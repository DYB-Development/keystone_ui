# frozen_string_literal: true

module Keystone
  module Ui
    class ActionListComponent < ViewComponent::Base
      ROW_CLASSES = "ks-value-list-row justify-between max-sm:flex-col max-sm:items-start sm:items-center"
      COMPACT_ROW_CLASSES = "ks-value-list-row justify-between max-sm:flex-col max-sm:items-start sm:items-center text-sm"
      TEXT_CLASSES = "min-w-0"
      BUTTON_CLASSES = "shrink-0"
      BUTTON_DEFAULTS = { size: :sm, variant: :secondary }.freeze

      attr_reader :rows

      def initialize(rows:, compact: false)
        @rows = rows
        @compact = compact
      end

      def row_classes
        @compact ? COMPACT_ROW_CLASSES : ROW_CLASSES
      end

      def button(row)
        Keystone::Ui::ButtonComponent.new(**BUTTON_DEFAULTS, **row[:button])
      end
    end
  end
end
