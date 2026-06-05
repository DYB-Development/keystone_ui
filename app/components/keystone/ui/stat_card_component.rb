# frozen_string_literal: true

module Keystone
  module Ui
    class StatCardComponent < ViewComponent::Base
      CARD_CLASSES = "rounded-xl border border-gray-200 bg-white p-6 dark:border-zinc-700 dark:bg-zinc-800"
      LABEL_CLASSES = "text-sm font-medium text-gray-500 dark:text-gray-400"
      VALUE_BASE_CLASSES = "mt-1 text-3xl font-bold"
      SUFFIX_CLASSES = "text-lg text-gray-500 dark:text-gray-400"

      VARIANT_CLASSES = {
        neutral: "text-gray-900 dark:text-white",
        success: "text-green-600 dark:text-green-400",
        danger: "text-red-600 dark:text-red-400",
        warning: "text-yellow-600 dark:text-yellow-400",
        info: "text-accent-600 dark:text-accent-400"
      }.freeze

      attr_reader :label, :value, :suffix, :definition, :calculation

      def initialize(label:, value:, variant: :neutral, suffix: nil, definition: nil, calculation: nil)
        @label = label
        @value = value
        @variant = variant
        @suffix = suffix
        @definition = definition
        @calculation = calculation
      end

      def classes
        CARD_CLASSES
      end

      def label_classes
        LABEL_CLASSES
      end

      def value_classes
        "#{VALUE_BASE_CLASSES} #{VARIANT_CLASSES.fetch(@variant)}"
      end

      def suffix_classes
        SUFFIX_CLASSES
      end

      def suffix?
        !@suffix.nil?
      end

      def info?
        !@definition.nil?
      end
    end
  end
end
