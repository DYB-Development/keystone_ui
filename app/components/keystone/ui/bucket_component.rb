# frozen_string_literal: true

module Keystone
  module Ui
    class BucketComponent < ViewComponent::Base
      CONTAINER_CLASSES = "ks-bucket flex w-24 flex-col items-center"
      LABEL_CLASSES = "ks-bucket-label text-center text-sm"
      GOAL_CLASSES = "ks-bucket-goal text-xs tabular-nums"
      TANK_CLASSES = "ks-bucket-tank flex h-40 w-full items-end overflow-hidden"
      ACTUAL_CLASSES = "ks-bucket-actual text-sm tabular-nums"
      PERCENT_CLASSES = "ks-bucket-percent text-xs tabular-nums text-gray-500 dark:text-gray-400"
      FILL_BASE_CLASSES = "w-full transition-all"
      WITHIN_GOAL_FILL_CLASSES = "bg-accent-500"
      OVER_GOAL_FILL_CLASSES = {
        success: "bg-green-500",
        warning: "bg-amber-500"
      }.freeze

      attr_reader :goal, :actual, :label

      def initialize(goal:, actual:, label: nil, over: :success)
        @goal = number(:goal, goal)
        @actual = number(:actual, actual)
        @label = label
        @over_fill_classes = OVER_GOAL_FILL_CLASSES.fetch(over)
      end

      def percent
        return 0 if goal.zero?

        (actual.to_f / goal * 100).round
      end

      def fill_percent
        [ percent, 100 ].min
      end

      def fill_classes
        "#{FILL_BASE_CLASSES} #{fill_color_classes}"
      end

      def container_classes
        CONTAINER_CLASSES
      end

      def label_classes
        LABEL_CLASSES
      end

      def goal_classes
        GOAL_CLASSES
      end

      def tank_classes
        TANK_CLASSES
      end

      def actual_classes
        ACTUAL_CLASSES
      end

      def percent_classes
        PERCENT_CLASSES
      end

      private

      def number(name, value)
        return value if value.is_a?(Numeric)

        raise ArgumentError, "#{name} must be a number, got #{value.inspect}"
      end

      def fill_color_classes
        return @over_fill_classes if actual > goal

        WITHIN_GOAL_FILL_CLASSES
      end
    end
  end
end
