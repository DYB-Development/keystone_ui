# frozen_string_literal: true

module Keystone
  module Ui
    class SelectComponent < ViewComponent::Base
      BASE_CLASSES = "block w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm text-gray-900 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 dark:bg-zinc-900 dark:border-zinc-700 dark:text-white dark:focus:border-indigo-400 dark:focus:ring-indigo-400"

      DISABLED_CLASSES = "cursor-not-allowed bg-gray-50 text-gray-500 dark:bg-zinc-800 dark:text-gray-400"

      attr_reader :options, :selected, :include_blank

      def initialize(name:, options: [], selected: nil, include_blank: nil, disabled: false)
        @name = name
        @options = options
        @selected = selected
        @include_blank = include_blank
        @disabled = disabled
      end

      def classes
        tokens = [BASE_CLASSES]
        tokens << DISABLED_CLASSES if @disabled
        tokens.join(" ")
      end

      def tag_options
        opts = {
          name: @name,
          class: classes
        }
        opts[:disabled] = true if @disabled
        opts
      end
    end
  end
end
