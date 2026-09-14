# frozen_string_literal: true

module Keystone
  module Ui
    class TextareaComponent < ViewComponent::Base
      BASE_CLASSES = "ks-input"

      DISABLED_CLASSES = "cursor-not-allowed bg-gray-50 text-gray-500 dark:bg-zinc-800 dark:text-gray-400"

      def initialize(name:, value: nil, rows: 3, placeholder: nil, disabled: false)
        @name = name
        @value = value
        @rows = rows
        @placeholder = placeholder
        @disabled = disabled
      end

      def classes
        tokens = [ BASE_CLASSES ]
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
