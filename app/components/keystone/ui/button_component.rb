# frozen_string_literal: true

module Keystone
  module Ui
    class ButtonComponent < ViewComponent::Base
      BASE_CLASSES = "inline-flex items-center justify-center font-semibold rounded-lg border-0 cursor-pointer no-underline"

      VARIANT_CLASSES = {
        secondary: "bg-gray-500 text-white hover:bg-gray-400",
        danger: "bg-red-600 text-white hover:bg-red-500"
      }.freeze

      SIZE_CLASSES = {
        sm: "text-sm px-3 py-1.5",
        md: "text-base px-4 py-2",
        lg: "text-lg px-5 py-3"
      }.freeze

      def initialize(label:, href: nil, variant: :primary, size: :md, type: :submit)
        @label = label
        @href = href
        @variant = variant
        @size = size
        @type = type.to_s
      end

      def classes
        variant_css = if @variant == :primary
          "bg-accent-600 text-white hover:bg-accent-500"
        else
          VARIANT_CLASSES.fetch(@variant)
        end
        [BASE_CLASSES, variant_css, SIZE_CLASSES.fetch(@size)].join(" ")
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
        options
      end

      def button?
        @href.nil?
      end
    end
  end
end
