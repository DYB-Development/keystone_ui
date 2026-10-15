# frozen_string_literal: true

module Keystone
  module Ui
    class BarChartComponent < ViewComponent::Base
      WIDTH = 600
      HEIGHT = 240
      LEFT = 40
      RIGHT = 8
      TOP = 18
      BOTTOM = 24
      BAR_SHARE = 0.7

      attr_reader :bars

      def initialize(bars:, show_values: false)
        @bars = bars
        @show_values = show_values
      end

      def show_values?
        @show_values
      end

      def drawn_bars
        bars.each_with_index.map do |bar, index|
          height = bar[:value].to_f / axis_max * plot_height
          { x: LEFT + (index * band) + (band * (1 - BAR_SHARE) / 2), y: TOP + plot_height - height, width: band * BAR_SHARE, height: height,
            center: LEFT + (index * band) + (band / 2), label: bar[:label], value: bar[:value],
            classes: [ "ks-bar-chart-bar", ("ks-bar-chart-bar-shaded" if bar[:shaded]) ].compact.join(" ") }
        end
      end

      def label_baseline
        HEIGHT - 6
      end

      private

      def axis_max
        [ bars.map { |bar| bar[:value].to_f }.max.to_f, 1 ].max
      end

      def band
        plot_width / [ bars.size, 1 ].max
      end

      def plot_width
        WIDTH - LEFT - RIGHT
      end

      def plot_height
        HEIGHT - TOP - BOTTOM
      end
    end
  end
end
