# frozen_string_literal: true

module Keystone
  module Ui
    class BarChartComponent < ViewComponent::Base
      attr_reader :bars

      def initialize(bars:)
        @bars = bars
      end
    end
  end
end
