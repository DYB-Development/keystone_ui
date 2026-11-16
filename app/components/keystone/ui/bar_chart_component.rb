# frozen_string_literal: true

module Keystone
  module Ui
    class BarChartComponent < ViewComponent::Base
      FRAME_CLASSES = "ks-bar-chart flex aspect-[5/2] max-h-80 w-full flex-col"
      STRIP_FRAME_CLASSES = "ks-bar-chart flex h-[114px] w-full flex-col"
      PLOT_ROW_CLASSES = "flex min-h-0 flex-1"
      AXIS_CLASSES = "h-full w-10 shrink-0 overflow-visible"
      PLOT_CLASSES = "relative min-w-0 flex-1"
      LAYER_CLASSES = "absolute inset-0 h-full w-full overflow-visible"
      LABEL_ROW_CLASSES = "flex h-6 shrink-0"
      LABEL_SPACER_CLASSES = "w-10 shrink-0"
      LABELS_CLASSES = "h-full min-w-0 flex-1 overflow-visible"
      FULL = 100.0
      HEADROOM = 8.0
      BAR_SHARE = 0.7
      STRIP_BAR_SHARE = 0.92
      TICK_COUNT = 4
      ROUND_STEPS = [ 1, 2, 2.5, 5, 10 ].freeze
      GROUP_TONES = 5

      attr_reader :bars

      def initialize(bars:, show_values: false, strip: false)
        @bars = bars
        @show_values = show_values
        @strip = strip
      end

      def strip?
        @strip
      end

      def frame_classes
        strip? ? STRIP_FRAME_CLASSES : FRAME_CLASSES
      end

      def show_values?
        @show_values
      end

      def drawn_bars
        bars.each_with_index.map do |bar, index|
          height = bar[:value].to_f / axis_max * (FULL - HEADROOM)
          x = (index * band) + (band * (1 - bar_share) / 2)
          center = (index * band) + (band / 2)
          { x: x, y: FULL - height, width: band * bar_share, height: height, center: center,
            label: bar[:label], label_x: bar.key?(:group) ? x : center, label_anchor: bar.key?(:group) ? "start" : "middle", value: bar[:value],
            classes: [ "ks-bar-chart-bar", ("ks-bar-chart-bar-shaded" if bar[:shaded]), group_class(bar) ].compact.join(" ") }
        end
      end

      def labelled_bars
        drawn_bars.each_with_index.filter_map do |bar, index|
          next unless starts_group?(index)

          newest_group_start?(index) ? bar.merge(label_x: FULL, label_anchor: "end") : bar
        end
      end

      def grid_lines
        strip? ? [ { y: FULL } ] : ticks
      end

      def ticks
        (0..(axis_max / step).round).map do |position|
          value = (step * position).round(6)
          { y: FULL - (value / axis_max * (FULL - HEADROOM)), label: (value % 1).zero? ? value.to_i.to_s : value.to_s }
        end
      end

      private

      def bar_share
        strip? ? STRIP_BAR_SHARE : BAR_SHARE
      end

      def newest_group_start?(index)
        groups.size > 1 && bars[index].key?(:group) && bars[index][:group] == groups.last
      end

      def starts_group?(index)
        index.zero? || !bars[index].key?(:group) || bars[index][:group] != bars[index - 1][:group]
      end

      def group_class(bar)
        return unless bar.key?(:group)

        "ks-bar-chart-bar-group-#{group_tone(groups.index(bar[:group]))}"
      end

      def group_tone(position)
        return GROUP_TONES if groups.size == 1
        return [ 1, position - groups.size + 1 + GROUP_TONES ].max if groups.size > GROUP_TONES

        1 + (position * (GROUP_TONES - 1).to_f / (groups.size - 1)).round
      end

      def groups
        @groups ||= bars.map { |bar| bar[:group] }.uniq
      end

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
