# frozen_string_literal: true

module Keystone
  module Ui
    class ColorPickerComponent < ViewComponent::Base
      SWATCH_CLASSES = "w-10 h-10 rounded-lg border border-gray-300 dark:border-zinc-600 cursor-pointer"

      attr_reader :name, :value

      def initialize(name:, value: "#000000")
        @name = name
        @value = value
      end

      def controller_name
        "color-picker"
      end

      def swatch_classes
        SWATCH_CLASSES
      end
    end
  end
end
