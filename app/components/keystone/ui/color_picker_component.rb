# frozen_string_literal: true

module Keystone
  module Ui
    class ColorPickerComponent < ViewComponent::Base
      SWATCH_CLASSES = "ks-color-swatch w-10 h-10 cursor-pointer"

      LABEL_CLASSES = "ks-color-picker-label ks-label"

      PANEL_CLASSES = "ks-color-picker-panel absolute z-50 hidden"

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
