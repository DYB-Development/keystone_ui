# frozen_string_literal: true

module Keystone
  module Ui
    class StackedBarComponent < ViewComponent::Base
      BAR_CLASSES = "ks-stacked-bar flex h-7"
      SEGMENT_CLASSES = Fills::CLASSES.transform_values { |fill| "ks-stacked-bar-segment #{fill}" }.freeze

      attr_reader :segments

      def initialize(segments:)
        unknown = segments.map { |segment| segment[:tone] }.reject { |tone| SEGMENT_CLASSES.key?(tone) }
        raise ArgumentError, "Unknown stacked bar tone #{unknown.first.inspect}, expected one of #{SEGMENT_CLASSES.keys.join(', ')}" if unknown.any?

        @segments = segments
      end

      def drawn_segments
        segments.select { |segment| size(segment).positive? }
      end

      def segment_classes(segment)
        SEGMENT_CLASSES.fetch(segment[:tone])
      end

      def size(segment)
        segment.fetch(:size, segment[:amount])
      end
    end
  end
end
