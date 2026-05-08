# frozen_string_literal: true

module Keystone
  module Ui
    class TextareaComponent < ViewComponent::Base
      BASE_CLASSES = "block w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm text-gray-900 placeholder:text-gray-400 focus:outline-none focus:ring-1 dark:bg-zinc-900 dark:border-zinc-700 dark:text-white dark:placeholder:text-gray-500"

      DISABLED_CLASSES = "cursor-not-allowed bg-gray-50 text-gray-500 dark:bg-zinc-800 dark:text-gray-400"

      def initialize(name:, value: nil, rows: 3, placeholder: nil, disabled: false)
        @name = name
        @value = value
        @rows = rows
        @placeholder = placeholder
        @disabled = disabled
      end

      FOCUS_CLASSES = "focus:border-accent-500 focus:ring-accent-500 dark:focus:border-accent-400 dark:focus:ring-accent-400"

      def classes
        tokens = [ BASE_CLASSES, FOCUS_CLASSES ]
        tokens << DISABLED_CLASSES if @disabled
        tokens.join(" ")
      end

      def tag_options
        options = {
          name: @name,
          rows: @rows,
          class: classes
        }
        options[:placeholder] = @placeholder unless @placeholder.nil?
        options[:disabled] = true if @disabled
        options
      end
    end
  end
end
