# frozen_string_literal: true

module Keystone
  module Ui
    class ProgressComponent < ViewComponent::Base
      TRACK_CLASSES = "ks-progress-track w-full h-2 overflow-hidden"
      THIN_TRACK_CLASSES = "ks-progress-track w-full h-1 overflow-hidden"
      BAR_CLASSES = "ks-progress-bar h-full transition-all"
      LABEL_CLASSES = "ks-meter-label text-sm"

      attr_reader :value, :max, :label

      def initialize(value:, max:, label: nil, thin: false, tone: nil)
        @value = value
        @max = max
        @label = label
        @thin = thin
        @tone = tone
      end

      def percent
        [ (value.to_f / max * 100).round, 100 ].min
      end

      def track_classes
        @thin ? THIN_TRACK_CLASSES : TRACK_CLASSES
      end

      def bar_classes
        return BAR_CLASSES unless @tone

        "#{BAR_CLASSES} #{Fills::CLASSES.fetch(@tone)}"
      end

      def label_classes
        LABEL_CLASSES
      end
    end
  end
end
