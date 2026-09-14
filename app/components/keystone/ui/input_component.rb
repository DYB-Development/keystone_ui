# frozen_string_literal: true

module Keystone
  module Ui
    class InputComponent < ViewComponent::Base
      BASE_CLASSES = "ks-input"

      DISABLED_CLASSES = "cursor-not-allowed bg-gray-50 text-gray-500 dark:bg-zinc-800 dark:text-gray-400"

      TYPE_MAP = {
        text: "text",
        number: "number",
        email: "email",
        password: "password",
        date: "date"
      }.freeze

      def initialize(name:, type: :text, value: nil, placeholder: nil, disabled: false, min: nil, max: nil, step: nil)
        @name = name
        @type = type
        @value = value
        @placeholder = placeholder
        @disabled = disabled
        @min = min
        @max = max
        @step = step
      end

      def classes
        tokens = [ BASE_CLASSES ]
        tokens << DISABLED_CLASSES if @disabled
        tokens.join(" ")
      end

      def input_type
        TYPE_MAP.fetch(@type)
      end

      def tag_options
        options = {
          type: input_type,
          name: @name,
          class: classes
        }
        options[:value] = @value unless @value.nil?
        options[:placeholder] = @placeholder unless @placeholder.nil?
        options[:disabled] = true if @disabled
        options[:min] = @min unless @min.nil?
        options[:max] = @max unless @max.nil?
        options[:step] = @step unless @step.nil?
        options
      end
    end
  end
end
