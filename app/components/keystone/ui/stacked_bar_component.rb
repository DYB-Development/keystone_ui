# frozen_string_literal: true

module Keystone
  module Ui
    class StackedBarComponent < ViewComponent::Base
      BAR_CLASSES = "ks-stacked-bar flex h-7"
      AMOUNT_CLASSES = {
        1 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[3ch]:hidden",
        2 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[4ch]:hidden",
        3 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[5ch]:hidden",
        4 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[6ch]:hidden",
        5 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[7ch]:hidden",
        6 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[8ch]:hidden",
        7 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[9ch]:hidden",
        8 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[10ch]:hidden",
        9 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[11ch]:hidden",
        10 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[12ch]:hidden",
        11 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[13ch]:hidden",
        12 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[14ch]:hidden",
        13 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[15ch]:hidden",
        14 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[16ch]:hidden",
        15 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[17ch]:hidden",
        16 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[18ch]:hidden",
        17 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[19ch]:hidden",
        18 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[20ch]:hidden",
        19 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[21ch]:hidden",
        20 => "ks-stacked-bar-amount whitespace-nowrap overflow-hidden @max-[22ch]:hidden"
      }.freeze
      TIP_CLASSES = "ks-stacked-bar-tip absolute bottom-full"
      TIP_NAME_CLASSES = "ks-stacked-bar-tip-name block"
      TIP_VALUE_CLASSES = "ks-stacked-bar-tip-value block"
      SEGMENT_CLASSES = Fills::CLASSES.transform_values { |fill| "ks-stacked-bar-segment @container relative flex items-center min-w-0 #{fill}" }.freeze

      attr_reader :segments

      def initialize(segments:, total: nil, total_label: "the total")
        unknown = segments.map { |segment| segment[:tone] }.reject { |tone| SEGMENT_CLASSES.key?(tone) }
        raise ArgumentError, "Unknown stacked bar tone #{unknown.first.inspect}, expected one of #{SEGMENT_CLASSES.keys.join(', ')}" if unknown.any?

        @segments = segments
        @total = total
        @total_label = total_label
      end

      def drawn_segments
        segments.select { |segment| size(segment).positive? }
      end

      def segment_classes(segment)
        SEGMENT_CLASSES.fetch(segment[:tone])
      end

      def amount_classes(segment)
        AMOUNT_CLASSES.fetch(shown_amount(segment).length.clamp(1, AMOUNT_CLASSES.size))
      end

      def shown_amount(segment)
        segment.fetch(:value, segment[:amount]).to_s
      end

      def share(segment)
        "#{(segment[:amount].to_f / total * 100).round}% of #{@total_label}"
      end

      def total
        @total || drawn_segments.sum { |segment| segment[:amount] }
      end

      def size(segment)
        segment.fetch(:size, segment[:amount])
      end
    end
  end
end
