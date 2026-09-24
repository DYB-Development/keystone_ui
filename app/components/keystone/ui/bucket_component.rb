# frozen_string_literal: true

module Keystone
  module Ui
    class BucketComponent < ViewComponent::Base
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

      private

      def fill_color_classes
        return OVER_GOAL_FILL_CLASSES.fetch(@over) if actual > goal

        WITHIN_GOAL_FILL_CLASSES
      end
    end
  end
end
