# frozen_string_literal: true

module Keystone
  module Ui
    class BadgeComponent < ViewComponent::Base
      BASE_CLASSES = "inline-flex items-center rounded-full px-2 py-1 text-xs font-medium"

      VARIANT_CLASSES = {
        neutral: "bg-gray-100 text-gray-700 dark:bg-zinc-700 dark:text-gray-300",
        success: "bg-green-100 text-green-700 dark:bg-green-900/50 dark:text-green-400",
        danger: "bg-red-100 text-red-700 dark:bg-red-900/50 dark:text-red-400",
        warning: "bg-yellow-100 text-yellow-700 dark:bg-yellow-900/50 dark:text-yellow-400"
      }.freeze

      attr_reader :label

      def initialize(label:, variant: :neutral)
        @label = label
        @variant = variant
      end

      def classes
        variant_css = if @variant == :info
          "bg-accent-100 text-accent-700 dark:bg-accent-900/50 dark:text-accent-400"
        else
          VARIANT_CLASSES.fetch(@variant)
        end
        "#{BASE_CLASSES} #{variant_css}"
      end
    end
  end
end
