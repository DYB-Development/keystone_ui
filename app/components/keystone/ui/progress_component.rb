# frozen_string_literal: true

module Keystone
  module Ui
    class ProgressComponent < ViewComponent::Base
      attr_reader :value, :max, :label

      def initialize(value:, max:, label: nil)
        @value = value
        @max = max
        @label = label
      end

      def percent
        (value.to_f / max * 100).round
      end
    end
  end
end
