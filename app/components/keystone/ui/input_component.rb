# frozen_string_literal: true

module Keystone
  module Ui
    class InputComponent < ViewComponent::Base
      BASE_CLASSES = "ks-input"

      DISABLED_CLASSES = "ks-input-disabled"

      TYPE_MAP = {
        text: "text",
        number: "number",
        email: "email",
        password: "password",
        date: "date",
        datetime: "datetime-local"
      }.freeze

      DATETIME_FORMAT = "%Y-%m-%dT%H:%M"

      def self.formatted_value(type, value)
        return value unless type == :datetime && value.respond_to?(:strftime)

        value.strftime(DATETIME_FORMAT)
      end

      def initialize(name:, type: :text, value: nil, placeholder: nil, disabled: false, min: nil, max: nil, step: nil, autofocus: false, autocomplete: nil, autocapitalize: nil, inputmode: nil, required: false)
        @name = name
        @type = type
        @value = value
        @placeholder = placeholder
        @disabled = disabled
        @min = min
        @max = max
        @step = step
        @autofocus = autofocus
        @autocomplete = autocomplete
        @autocapitalize = autocapitalize
        @inputmode = inputmode
        @required = required
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
        options[:value] = self.class.formatted_value(@type, @value) unless @value.nil?
        options[:placeholder] = @placeholder unless @placeholder.nil?
        options[:disabled] = true if @disabled
        options[:min] = @min unless @min.nil?
        options[:max] = @max unless @max.nil?
        options[:step] = @step unless @step.nil?
        options[:autofocus] = true if @autofocus
        options[:autocomplete] = @autocomplete unless @autocomplete.nil?
        options[:autocapitalize] = @autocapitalize unless @autocapitalize.nil?
        options[:inputmode] = @inputmode unless @inputmode.nil?
        options[:required] = true if @required
        options
      end
    end
  end
end
