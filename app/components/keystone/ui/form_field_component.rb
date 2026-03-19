# frozen_string_literal: true

module Keystone
  module Ui
    class FormFieldComponent < ViewComponent::Base
      WRAPPER_CLASSES = "space-y-1"
      LABEL_CLASSES = "block text-sm font-medium text-gray-700 dark:text-gray-300"
      REQUIRED_CLASSES = "text-red-500 ml-0.5"
      HINT_CLASSES = "mt-1 text-sm text-gray-500 dark:text-gray-400"
      ERROR_CLASSES = "mt-1 text-sm text-red-600 dark:text-red-400"
      CHECKBOX_CLASSES = "rounded border-gray-300 text-accent-600 focus:ring-accent-500 dark:border-zinc-600 dark:bg-zinc-900"
      CHECKBOX_WRAPPER_CLASSES = "flex items-center gap-2"

      def initialize(attribute:, label: nil, type: :text, required: false, hint: nil, placeholder: nil, min: nil, max: nil, step: nil, value: nil, options: [], errors: [])
        @attribute = attribute
        @label = label
        @type = type
        @required = required
        @hint = hint
        @placeholder = placeholder
        @min = min
        @max = max
        @step = step
        @value = value
        @options = options
        @errors = Array(errors)
      end

      def label_text
        @label || @attribute.to_s.tr("_", " ").capitalize
      end

      def required?
        @required
      end

      def hint?
        !@hint.nil?
      end

      def hint_text
        @hint
      end

      def errors?
        @errors.any?
      end

      def error_messages
        @errors
      end

      def textarea?
        @type == :textarea
      end

      def checkbox?
        @type == :checkbox
      end

      def select?
        @type == :select
      end

      def select_options
        @options
      end

      def input_options
        options = { name: @attribute.to_s }
        unless textarea?
          options[:type] = Keystone::Ui::InputComponent::TYPE_MAP.fetch(@type)
        end
        options[:placeholder] = @placeholder unless @placeholder.nil?
        options[:value] = @value unless @value.nil?
        options[:min] = @min unless @min.nil?
        options[:max] = @max unless @max.nil?
        options[:step] = @step unless @step.nil?
        options
      end
    end
  end
end
