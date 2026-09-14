# frozen_string_literal: true

module Keystone
  module Ui
    class CheckboxRowComponent < ViewComponent::Base
      ROW_CLASSES = "flex items-start gap-3 py-3 cursor-pointer"
      INPUT_CLASSES = "mt-0.5 size-4 shrink-0 rounded border-surface-300 text-accent-600 focus:ring-accent-500"
      LABEL_CLASSES = "block text-sm font-medium text-surface-900 dark:text-surface-100"
      HINT_CLASSES = "block mt-0.5 text-sm text-surface-500 dark:text-surface-400"

      attr_reader :name, :value, :label, :hint

      def initialize(name:, value:, label:, hint: nil, checked: false)
        @name = name
        @value = value
        @label = label
        @hint = hint
        @checked = checked
      end

      def checked?
        @checked
      end

      def hint?
        !@hint.nil?
      end

      def row_classes
        ROW_CLASSES
      end

      def input_classes
        INPUT_CLASSES
      end

      def label_classes
        LABEL_CLASSES
      end

      def hint_classes
        HINT_CLASSES
      end
    end
  end
end
