# frozen_string_literal: true

module Keystone
  module Ui
    class ColorPickerComponent < ViewComponent::Base
      SWATCH_CLASSES = "w-10 h-10 rounded-lg border border-gray-300 dark:border-zinc-600 cursor-pointer"

      PANEL_CLASSES = "absolute z-50 mt-2 p-3 rounded-lg shadow-lg bg-white dark:bg-zinc-800 border border-gray-200 dark:border-zinc-700 hidden"

      attr_reader :name, :value, :label

      def initialize(name:, value: "#000000", label: nil)
        @name = name
        @value = value
        @label = label
      end

      def controller_name
        "color-picker"
      end

      def swatch_classes
        SWATCH_CLASSES
      end

      def panel_classes
        PANEL_CLASSES
      end
    end
  end
end
