# frozen_string_literal: true

module Keystone
  module Ui
    class OptionCardComponent < ViewComponent::Base
      BASE_CLASSES = "ks-option-card inline-flex items-center transition cursor-pointer"

      attr_reader :name, :value, :input_data, :label_data

      def initialize(name:, value:, selected: false, input_data: {}, label_data: {})
        @name = name
        @value = value
        @selected = selected
        @input_data = input_data
        @label_data = label_data
      end

      def selected?
        @selected
      end

      def classes
        border = selected? ? "border-accent-500" : "border-transparent"
        "#{BASE_CLASSES} #{border}"
      end
    end
  end
end
