# frozen_string_literal: true

module Keystone
  module Ui
    class BadgeComponent < ViewComponent::Base
      BASE_CLASSES = "inline-flex items-center rounded-full px-2 py-1 text-xs font-medium"

      VARIANT_CLASSES = {
        neutral: "bg-gray-100 text-gray-700 dark:bg-zinc-700 dark:text-gray-300",
        success: "bg-green-100 text-green-700 dark:bg-green-900/50 dark:text-green-400",
        danger: "bg-red-100 text-red-700 dark:bg-red-900/50 dark:text-red-400",
        warning: "bg-yellow-100 text-yellow-700 dark:bg-yellow-900/50 dark:text-yellow-400",
        info: "bg-blue-100 text-blue-700 dark:bg-blue-900/50 dark:text-blue-400"
      }.freeze

      attr_reader :label

      def initialize(label:, variant: :neutral)
        @label = label
        @variant = variant
      end

      def classes
        [BASE_CLASSES, VARIANT_CLASSES.fetch(@variant)].join(" ")
      end
    end
  end
end
