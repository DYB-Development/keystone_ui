# frozen_string_literal: true

module Keystone
  module Ui
    class FunnelComponent < ViewComponent::Base
      Layer = Struct.new(:label, :value, :width_percent, :conversion_percent, keyword_init: true)

      CONTAINER_CLASSES = "space-y-2"
      LAYER_CLASSES = "space-y-1"
      ROW_CLASSES = "flex items-baseline justify-between gap-3"
      LABEL_CLASSES = "text-sm font-medium text-surface-700 truncate"
      VALUE_CLASSES = "text-sm font-semibold text-surface-900 tabular-nums"
      BAR_CLASSES = "h-8 rounded-md bg-accent-500 transition-all"
      TRANSITION_CLASSES = "py-1 text-center text-xs text-surface-500"

      attr_reader :steps

      def initialize(steps:)
        @steps = steps
      end

      def layers
        previous = nil

        steps.map do |step|
          layer = Layer.new(
            label: step[:label],
            value: step[:value],
            width_percent: width_percent(step[:value]),
            conversion_percent: conversion_percent(step[:value], previous)
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
