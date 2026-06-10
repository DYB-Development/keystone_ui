# frozen_string_literal: true

module Keystone
  module Ui
    class ProgressComponent < ViewComponent::Base
      TRACK_CLASSES = "w-full h-2 bg-surface-200 rounded-full overflow-hidden"

      attr_reader :value, :max, :label

      def initialize(value:, max:, label: nil)
        @value = value
        @max = max
        @label = label
      end

      def percent
        [(value.to_f / max * 100).round, 100].min
      end

      def track_classes
        TRACK_CLASSES
      end
    end
  end
end
