# frozen_string_literal: true

module Keystone
  module Ui
    class ActionListComponent < ViewComponent::Base
      ROW_CLASSES = "ks-value-list-row justify-between max-sm:flex-col max-sm:items-start sm:items-center"
      TEXT_CLASSES = "min-w-0"
      BUTTON_CLASSES = "shrink-0"
      BUTTON_DEFAULTS = { size: :sm, variant: :secondary }.freeze

      attr_reader :rows

      def initialize(rows:)
        @rows = rows
      end

      def row_classes
        ROW_CLASSES
      end

      def button(row)
        Keystone::Ui::ButtonComponent.new(**BUTTON_DEFAULTS, **row[:button])
      end
    end
  end
end
