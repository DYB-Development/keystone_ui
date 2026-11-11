# frozen_string_literal: true

module Keystone
  module Ui
    class ButtonComponent < ViewComponent::Base
      BASE_CLASSES = "ks-button"

      VARIANT_CLASSES = {
        secondary: "ks-button-secondary",
        danger: "ks-button-danger"
      }.freeze

      SIZE_CLASSES = {
        sm: "ks-button-sm",
        md: "ks-button-md",
        lg: "ks-button-lg"
      }.freeze

      FULL_WIDTH_CLASSES = "w-full"

      TEXT_CLASSES = "ks-text-button"

      def initialize(label:, href: nil, method: :get, variant: :primary, size: :md, full_width: false, type: :submit, data: nil, name: nil, value: nil, hidden: false)
        @label = label
        @href = href
        @method = method.to_sym
        @full_width = full_width
        @variant = variant
        @size = size
        @type = type.to_s
        @data = data
        @name = name
        @value = value
        @hidden = hidden
      end

      def classes
        return TEXT_CLASSES if @variant == :text

        variant_css = if @variant == :primary
          "ks-button-primary"
        else
          VARIANT_CLASSES.fetch(@variant)
        end
        [ BASE_CLASSES, variant_css, SIZE_CLASSES.fetch(@size), (FULL_WIDTH_CLASSES if @full_width) ].compact.join(" ")
      end

      def tag_name
        button? ? :button : :a
      end

      def tag_options
        options = { class: classes }
        if button?
          options[:type] = @type
          options[:name] = @name if @name
          options[:value] = @value if @value
        else
          options[:href] = @href
        end
        options[:data] = @data if @data
        options[:hidden] = true if @hidden
        options
      end

      def button?
        @href.nil?
      end

      def call
        return button_to(@href, method: @method, class: classes, form_class: form_classes) { @label } if request?

        content_tag(tag_name, @label, **tag_options)
      end

      def form_classes
        FULL_WIDTH_CLASSES if @full_width
      end

      def request?
        @href && @method != :get
      end
    end
  end
end
