# frozen_string_literal: true

module Keystone
  module Ui
    class BarChartComponent < ViewComponent::Base
      FRAME_CLASSES = "ks-bar-chart flex aspect-[5/2] max-h-80 w-full flex-col pr-2"
      PLOT_ROW_CLASSES = "flex min-h-0 flex-1 pt-[18px]"
      AXIS_CLASSES = "h-full w-10 shrink-0 overflow-visible"
      PLOT_CLASSES = "relative min-w-0 flex-1"
      LAYER_CLASSES = "absolute inset-0 h-full w-full overflow-visible"
      LABEL_ROW_CLASSES = "ml-10 h-6 shrink-0 overflow-visible"
      FULL = 100.0
      BAR_SHARE = 0.7
      TICK_COUNT = 4
      ROUND_STEPS = [ 1, 2, 2.5, 5, 10 ].freeze

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
          height = bar[:value].to_f / axis_max * FULL
          { x: (index * band) + (band * (1 - BAR_SHARE) / 2), y: FULL - height, width: band * BAR_SHARE, height: height,
            center: (index * band) + (band / 2), label: bar[:label], value: bar[:value],
            classes: [ "ks-bar-chart-bar", ("ks-bar-chart-bar-shaded" if bar[:shaded]) ].compact.join(" ") }
        end
      end

      def ticks
        (0..(axis_max / step).round).map do |position|
          value = (step * position).round(6)
          { y: FULL - (value / axis_max * FULL), label: (value % 1).zero? ? value.to_i.to_s : value.to_s }
        end
      end

      private

      def axis_max
        step * (largest / step).ceil
      end

      def step
        @step ||= begin
          raw = largest / TICK_COUNT
          magnitude = 10.0**Math.log10(raw).floor
          ROUND_STEPS.map { |round| round * magnitude }.find { |candidate| candidate >= raw }
        end
      end

      def largest
        bars.map { |bar| bar[:value].to_f }.select(&:positive?).max || 1.0
      end

      def band
        FULL / [ bars.size, 1 ].max
      end
    end
  end
end
