# frozen_string_literal: true

module Keystone
  module Ui
    class MultiSelectComponent < ViewComponent::Base
      WRAPPER_CLASSES = "relative inline-block"
      TRIGGER_CLASSES = "inline-flex items-center gap-1 rounded-md border px-3 py-2 text-sm border-gray-300 bg-white text-gray-900 dark:border-zinc-700 dark:bg-zinc-900 dark:text-white"
      MENU_CLASSES = "absolute z-10 mt-1 w-56 rounded-md border border-gray-200 bg-white shadow-lg dark:border-zinc-700 dark:bg-zinc-900 hidden"
      OPTION_CLASSES = "flex items-center gap-2 px-3 py-2 text-sm text-gray-700 hover:bg-gray-50 dark:text-gray-300 dark:hover:bg-zinc-800 cursor-pointer"
      CHECKBOX_CLASSES = "rounded border-gray-300 text-accent-600 focus:ring-accent-500 dark:border-zinc-600"
      CARET_ICON = <<~SVG.freeze
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-4 h-4">
          <path fill-rule="evenodd" d="M5.22 8.22a.75.75 0 0 1 1.06 0L10 11.94l3.72-3.72a.75.75 0 1 1 1.06 1.06l-4.25 4.25a.75.75 0 0 1-1.06 0L5.22 9.28a.75.75 0 0 1 0-1.06Z" clip-rule="evenodd" />
        </svg>
      SVG

      attr_reader :name, :label, :options, :selected

      def initialize(name:, label:, options:, selected: [])
        @name = name
        @label = label
        @options = options
        @selected = Array(selected).map(&:to_s)
      end

      def selected?(value)
        @selected.include?(value.to_s)
      end

      def display_text
        checked = @selected.reject(&:empty?)
        if checked.empty?
          "All #{@label}"
        else
          "#{checked.length} selected"
        end
      end
    end
  end
end
