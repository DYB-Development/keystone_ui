# frozen_string_literal: true

module Keystone
  module Ui
    class RadioCardComponent < ViewComponent::Base
      BASE_CLASSES = "inline-flex flex-col px-4 py-3 rounded-lg border-2 cursor-pointer transition"
      HIGHLIGHT_CLASSES = "border-gray-200 dark:border-zinc-700 peer-checked:border-accent-500 peer-checked:bg-accent-50 dark:peer-checked:bg-zinc-800"
      LABEL_CLASSES = "block font-medium text-gray-900 dark:text-gray-100"
      HINT_CLASSES = "block mt-1 text-sm text-surface-500 dark:text-gray-400"

      attr_reader :name, :value, :label, :hint

      def initialize(name:, value:, label:, hint: nil, checked: false)
        @name = name
        @value = value
        @label = label
        @hint = hint
        @checked = checked
      end

      def checked?
        @checked
      end

      def hint?
        !@hint.nil?
      end

      def classes
        "#{BASE_CLASSES} #{HIGHLIGHT_CLASSES}"
      end

      def label_classes
        LABEL_CLASSES
      end

      def hint_classes
        HINT_CLASSES
      end
    end
  end
end
