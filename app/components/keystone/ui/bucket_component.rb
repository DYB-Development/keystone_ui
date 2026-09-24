# frozen_string_literal: true

module Keystone
  module Ui
    class BucketComponent < ViewComponent::Base
      FILL_CLASSES = "w-full bg-accent-500 transition-all"

      attr_reader :goal, :actual

      def initialize(goal:, actual:)
        @goal = goal
        @actual = actual
      end

      def percent
        return 0 if goal.zero?

        (actual.to_f / goal * 100).round
      end

      def fill_percent
        [ percent, 100 ].min
      end

      def fill_classes
        FILL_CLASSES
      end
    end
  end
end
