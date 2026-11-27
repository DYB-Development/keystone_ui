# frozen_string_literal: true

module Keystone
  module Ui
    class StackedBarComponent < ViewComponent::Base
      BAR_CLASSES = "ks-stacked-bar flex h-7"
      SEGMENT_CLASSES = "ks-stacked-bar-segment"

      attr_reader :segments

      def initialize(segments:)
        @segments = segments
      end

      def drawn_segments
        segments.select { |segment| size(segment).positive? }
      end

      def size(segment)
        segment[:amount]
      end
    end
  end
end
