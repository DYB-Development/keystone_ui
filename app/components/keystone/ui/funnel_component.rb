# frozen_string_literal: true

module Keystone
  module Ui
    class FunnelComponent < ViewComponent::Base
      Layer = Struct.new(:label, :value, :width_percent, :conversion_percent, :color_classes, keyword_init: true)

      CONTAINER_CLASSES = "ks-funnel"
      LAYER_CLASSES = "ks-funnel-layer"
      ROW_CLASSES = "ks-funnel-row flex items-baseline justify-between"
      LABEL_CLASSES = "ks-funnel-label text-sm truncate"
      VALUE_CLASSES = "ks-funnel-value text-sm tabular-nums"
      BAR_CLASSES = "ks-funnel-bar h-8 transition-all"
      TRANSITION_CLASSES = "ks-funnel-transition text-center text-xs"
      STEP_COLOR_CLASSES = {
        accent: "ks-funnel-bar-accent",
        sky: "ks-funnel-bar-sky",
        violet: "ks-funnel-bar-violet",
        amber: "ks-funnel-bar-amber",
        rose: "ks-funnel-bar-rose"
      }.freeze

      attr_reader :steps, :shape

      def initialize(steps:, shape: :bars)
        raise ArgumentError, "a funnel's shape is :bars or :joined, got #{shape.inspect}" unless %i[bars joined].include?(shape)

        @steps = steps
        @shape = shape
      end

      def joined?
        shape == :joined
      end

      def layers
        previous = nil

        steps.each_with_index.map do |step, index|
          layer = Layer.new(
            label: step[:label],
            value: step[:value],
            width_percent: width_percent(step[:value]),
            conversion_percent: conversion_percent(step[:value], previous),
            color_classes: color_classes(step[:color], index)
          )
          previous = step[:value]
          layer
        end
      end

      def container_classes
        CONTAINER_CLASSES
      end

      def layer_classes
        LAYER_CLASSES
      end

      def row_classes
        ROW_CLASSES
      end

      def bar_classes
        BAR_CLASSES
      end

      def label_classes
        LABEL_CLASSES
      end

      def value_classes
        VALUE_CLASSES
      end

      def transition_classes
        TRANSITION_CLASSES
      end

      private

      def color_classes(color, index)
        return STEP_COLOR_CLASSES.fetch(color) if color

        STEP_COLOR_CLASSES.values[index % STEP_COLOR_CLASSES.size]
      end

      def conversion_percent(value, previous)
        return nil if previous.nil?
        return 0 if previous.zero?

        (value.to_f / previous * 100).round
      end

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
