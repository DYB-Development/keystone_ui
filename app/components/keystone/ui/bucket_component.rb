# frozen_string_literal: true

module Keystone
  module Ui
    class BucketComponent < ViewComponent::Base
      attr_reader :goal, :actual

      def initialize(goal:, actual:)
        @goal = goal
        @actual = actual
      end

      def percent
        (actual.to_f / goal * 100).round
      end
    end
  end
end
