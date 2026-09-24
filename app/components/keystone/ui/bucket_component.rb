# frozen_string_literal: true

module Keystone
  module Ui
    class BucketComponent < ViewComponent::Base
      CONTAINER_CLASSES = "flex w-24 flex-col items-center gap-1"
      LABEL_CLASSES = "text-center text-sm font-medium text-gray-700 dark:text-gray-300"
      GOAL_CLASSES = "text-xs tabular-nums text-gray-500 dark:text-gray-400"
      TANK_CLASSES = "flex h-40 w-full items-end overflow-hidden rounded-t-sm rounded-b-xl border-2 border-gray-300 bg-gray-50 dark:border-zinc-600 dark:bg-zinc-800"
      ACTUAL_CLASSES = "text-sm font-semibold tabular-nums text-gray-900 dark:text-white"
      PERCENT_CLASSES = "text-xs tabular-nums text-gray-500 dark:text-gray-400"
      FILL_BASE_CLASSES = "w-full transition-all"
      WITHIN_GOAL_FILL_CLASSES = "bg-accent-500"
      OVER_GOAL_FILL_CLASSES = {
        success: "bg-green-500",
        warning: "bg-amber-500"
      }.freeze

      attr_reader :goal, :actual, :label

      def initialize(goal:, actual:, label: nil, over: :success)
        @goal = goal
        @actual = actual
        @label = label
        @over = over
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

      def fill_color_classes
        return OVER_GOAL_FILL_CLASSES.fetch(@over) if actual > goal

        WITHIN_GOAL_FILL_CLASSES
      end
    end
  end
end
