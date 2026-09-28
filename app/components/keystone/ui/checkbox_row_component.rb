# frozen_string_literal: true

module Keystone
  module Ui
    class CheckboxRowComponent < ViewComponent::Base
      ROW_CLASSES = "ks-checkbox-row flex items-start cursor-pointer"
      INPUT_CLASSES = "ks-checkbox-row-input size-4 shrink-0"
      LABEL_CLASSES = "ks-checkbox-row-label block text-sm"
      HINT_CLASSES = "ks-checkbox-row-hint block mt-0.5 text-sm text-surface-500 dark:text-surface-400"

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
