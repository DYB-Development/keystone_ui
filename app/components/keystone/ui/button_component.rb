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

      def initialize(label:, href: nil, variant: :primary, size: :md, type: :submit, data: nil)
        @label = label
        @href = href
        @variant = variant
        @size = size
        @type = type.to_s
        @data = data
      end

      def classes
        variant_css = if @variant == :primary
          "ks-button-primary"
        else
          VARIANT_CLASSES.fetch(@variant)
        end
        [ BASE_CLASSES, variant_css, SIZE_CLASSES.fetch(@size) ].join(" ")
      end

      def tag_name
        button? ? :button : :a
      end

      def tag_options
        options = { class: classes }
        if button?
          options[:type] = @type
        else
          options[:href] = @href
        end
        options[:data] = @data if @data
        options
      end

      def button?
        @href.nil?
      end
    end
  end
end
