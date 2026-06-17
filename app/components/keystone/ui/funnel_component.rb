# frozen_string_literal: true

module Keystone
  module Ui
    class FunnelComponent < ViewComponent::Base
      Layer = Struct.new(:label, :value, :width_percent, :conversion_percent, keyword_init: true)

      BAR_CLASSES = "flex items-center justify-between gap-3 h-10 px-3 bg-accent-500 text-white rounded-md transition-all"

      attr_reader :steps

      def bar_classes
        BAR_CLASSES
      end

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
