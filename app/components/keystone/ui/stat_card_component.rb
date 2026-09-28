# frozen_string_literal: true

module Keystone
  module Ui
    class StatCardComponent < ViewComponent::Base
      HEADER_CLASSES = "ks-stat-card-header flex items-start justify-between"
      CARD_CLASSES = "ks-metric-card relative"
      LABEL_CLASSES = "ks-stat-card-label text-sm"
      VALUE_BASE_CLASSES = "ks-stat-card-value text-3xl"
      SUFFIX_CLASSES = "ks-stat-card-suffix text-lg"
      DISCLOSURE_CLASSES = "ks-stat-card-disclosure hidden peer-hover:block peer-focus-visible:block absolute inset-x-0 top-full z-10 text-sm"
      CHANGE_ROW_CLASSES = "ks-stat-card-change h-5 text-sm"
      VALUE_LINK_CLASSES = "hover:underline focus:outline-none focus-visible:underline"
      INFO_BUTTON_CLASSES = "ks-stat-card-info peer shrink-0 transition"

      INFO_ICON = <<~SVG.freeze
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
      SVG

      VARIANT_CLASSES = {
        neutral: "ks-tone-neutral",
        success: "ks-tone-success",
        danger: "ks-tone-danger",
        warning: "ks-tone-warning",
        info: "ks-tone-info"
      }.freeze

      attr_reader :label, :value, :suffix, :definition, :calculation, :change, :href

      def initialize(label:, value:, variant: :neutral, suffix: nil, definition: nil, calculation: nil, change: nil, href: nil)
        @label = label
        @value = value
        @variant = variant
        @suffix = suffix
        @definition = definition
        @calculation = calculation
        @change = change
        @href = href
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

      def link?
        !@href.nil?
      end

      def value_link_classes
        VALUE_LINK_CLASSES
      end

      def change_label
        return "" unless change?

        formatted = "#{format("%.1f", @change.abs)}%"
        return formatted if @change.zero?

        "#{@change.negative? ? "▼" : "▲"} #{formatted}"
      end

      def change_row_classes
        "#{CHANGE_ROW_CLASSES} #{change_classes}"
      end

      def change_classes
        return "ks-tone-muted" if !change? || @change.zero?
        return "ks-tone-danger" if @change.negative?

        "ks-tone-success"
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
