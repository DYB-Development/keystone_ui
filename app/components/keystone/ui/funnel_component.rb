# frozen_string_literal: true

module Keystone
  module Ui
    class FunnelComponent < ViewComponent::Base
      Layer = Struct.new(:label, :value, :width_percent, keyword_init: true)

      attr_reader :steps

      def initialize(steps:)
        @steps = steps
      end

      def layers
        steps.map do |step|
          Layer.new(
            label: step[:label],
            value: step[:value],
            width_percent: width_percent(step[:value])
          )
        end
      end

      private

      def top_value
        steps.first[:value].to_f
      end

      def width_percent(value)
        return 0 if top_value.zero?

        (value.to_f / top_value * 100).round
      end
    end
  end
end
