# frozen_string_literal: true

module Keystone
  module Ui
    class StatCardComponent < ViewComponent::Base
      EMPHASIS_CLASSES = "ks-stat-card-emphasis"
      HEADER_CLASSES = "ks-stat-card-header flex items-start justify-between"
      CARD_CLASSES = "ks-metric-card relative"
      PLAIN_CLASSES = "ks-metric-plain relative"
      COMPACT_CLASSES = "ks-metric-card ks-metric-card-compact relative"
      LABEL_CLASSES = "ks-stat-card-label text-sm"
      COMPACT_LABEL_CLASSES = "ks-stat-card-label text-xs"
      CAPS_LABEL_CLASSES = "ks-stat-card-label ks-label-caps"
      VALUE_BASE_CLASSES = "ks-stat-card-value text-3xl"
      VALUE_SIZE_CLASSES = { lg: VALUE_BASE_CLASSES, sm: "ks-stat-card-value ks-stat-card-value-sm whitespace-nowrap" }.freeze
      COMPACT_VALUE_CLASSES = "ks-stat-card-value ks-stat-card-value-compact flex flex-wrap items-baseline text-lg leading-6"
      SUFFIX_CLASSES = "ks-stat-card-suffix text-lg"
      DISCLOSURE_CLASSES = "ks-stat-card-disclosure hidden peer-hover:block peer-focus-visible:block absolute inset-x-0 top-full z-10 text-sm"
      CHANGE_ROW_CLASSES = "ks-stat-card-change h-5 text-sm"
      COMPACT_CHANGE_CLASSES = "ks-stat-card-change text-xs"
      VALUE_LINK_CLASSES = "hover:underline focus:outline-none focus-visible:underline"
      INFO_BUTTON_CLASSES = "ks-stat-card-info peer shrink-0 transition"
      NOTE_CLASSES = "ks-stat-card-note text-sm"
      COMPACT_NOTE_CLASSES = "ks-stat-card-note text-xs"
      FALLBACK_CLASSES = "ks-stat-card-fallback"

      INFO_ICON = <<~SVG.freeze
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
      SVG

      VARIANT_CLASSES = States::NAMES.to_h { |state| [ state, "ks-tone-#{state}" ] }.freeze

      attr_reader :label, :value, :suffix, :definition, :calculation, :change, :href, :note

      def initialize(label:, value:, variant: :neutral, suffix: nil, definition: nil, calculation: nil, change: nil, href: nil, note: nil, plain: false, fallback: nil, compact: false, label_caps: false, value_size: :lg)
        @value_size = value_size
        @compact = compact
        @label_caps = label_caps
        @label = label
        @fallback = fallback
        @note = note
        @plain = plain
        @value = value
        @variant = variant
        @suffix = suffix
        @definition = definition
        @calculation = calculation
        @change = change
        @href = href
      end

      def missing?
        @value.to_s.empty? && !@fallback.nil?
      end

      def fallback
        @fallback
      end

      def classes
        return COMPACT_CLASSES if @compact

        @plain ? PLAIN_CLASSES : CARD_CLASSES
      end

      def label_classes
        return CAPS_LABEL_CLASSES if @label_caps

        @compact || @value_size == :sm ? COMPACT_LABEL_CLASSES : LABEL_CLASSES
      end

      def value_classes
        "#{@compact ? COMPACT_VALUE_CLASSES : VALUE_SIZE_CLASSES.fetch(@value_size)} #{VARIANT_CLASSES.fetch(@variant)}"
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

      def compact?
        @compact
      end

      def compact_change_classes
        "#{COMPACT_CHANGE_CLASSES} #{change_classes}"
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
