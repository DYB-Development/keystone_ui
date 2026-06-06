# frozen_string_literal: true

module Keystone
  module Ui
    class StatCardComponent < ViewComponent::Base
      CARD_CLASSES = "rounded-xl border border-gray-200 bg-white p-6 dark:border-zinc-700 dark:bg-zinc-800"
      LABEL_CLASSES = "text-sm font-medium text-gray-500 dark:text-gray-400"
      VALUE_BASE_CLASSES = "mt-1 text-3xl font-bold"
      SUFFIX_CLASSES = "text-lg text-gray-500 dark:text-gray-400"
      DISCLOSURE_CLASSES = "hidden mt-4 space-y-1 border-t border-gray-200 pt-3 text-sm text-gray-600 dark:border-zinc-700 dark:text-gray-400"
      INFO_BUTTON_CLASSES = "shrink-0 text-gray-400 transition hover:text-accent-600 dark:hover:text-accent-400"

      INFO_ICON = <<~SVG.freeze
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
      SVG

      VARIANT_CLASSES = {
        neutral: "text-gray-900 dark:text-white",
        success: "text-green-600 dark:text-green-400",
        danger: "text-red-600 dark:text-red-400",
        warning: "text-yellow-600 dark:text-yellow-400",
        info: "text-accent-600 dark:text-accent-400"
      }.freeze

      attr_reader :label, :value, :suffix, :definition, :calculation, :change

      def initialize(label:, value:, variant: :neutral, suffix: nil, definition: nil, calculation: nil, change: nil)
        @label = label
        @value = value
        @variant = variant
        @suffix = suffix
        @definition = definition
        @calculation = calculation
        @change = change
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
        !@definition.nil? || !@calculation.nil?
      end

      def change?
        !@change.nil?
      end

      def change_label
        arrow = @change.negative? ? "▼" : "▲"
        "#{arrow} #{format("%.1f", @change.abs)}%"
      end

      def change_classes
        return "text-gray-500 dark:text-gray-400" if @change.zero?
        return "text-red-600 dark:text-red-400" if @change.negative?

        "text-green-600 dark:text-green-400"
      end

      def disclosure_classes
        DISCLOSURE_CLASSES
      end

      def info_button_classes
        INFO_BUTTON_CLASSES
      end

      def info_icon
        INFO_ICON
      end
    end
  end
end
