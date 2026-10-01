# frozen_string_literal: true

module Keystone
  module Ui
    class FormFieldComponent < ViewComponent::Base
      WRAPPER_CLASSES = "ks-form-field"
      LABEL_CLASSES = "ks-label"
      REQUIRED_CLASSES = "ks-required"
      HINT_CLASSES = "ks-hint"
      ERROR_CLASSES = "ks-error"
      CHECKBOX_CLASSES = "ks-checkbox"
      CHECKBOX_WRAPPER_CLASSES = "ks-form-field-checkbox flex items-center"

      def initialize(attribute:, label: nil, type: :text, required: false, hint: nil, placeholder: nil, min: nil, max: nil, step: nil, value: nil, options: [], errors: [], include_blank: nil, disabled: false, suggestions: [])
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
        @include_blank = include_blank.to_s
        @disabled = disabled
        @suggestions = Array(suggestions)
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

      def blank_option_text
        @include_blank
      end

      def input_options
        options = { name: @attribute.to_s, class: Keystone::Ui::InputComponent::BASE_CLASSES }
        unless textarea?
          options[:type] = Keystone::Ui::InputComponent::TYPE_MAP.fetch(@type)
        end
        options[:placeholder] = @placeholder unless @placeholder.nil?
        options[:value] = @value unless @value.nil?
        options[:min] = @min unless @min.nil?
        options[:max] = @max unless @max.nil?
        options[:step] = @step unless @step.nil?
        options[:disabled] = true if @disabled
        options[:list] = suggestions_id if suggestions?
        options
      end

      def suggestions?
        @suggestions.any?
      end

      def suggestions
        @suggestions
      end

      def suggestions_id
        "#{@attribute.to_s.parameterize}-suggestions"
      end
    end
  end
end
