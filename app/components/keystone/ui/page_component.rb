# frozen_string_literal: true

module Keystone
  module Ui
    class PageComponent < ViewComponent::Base
      MAX_WIDTH_CLASSES = {
        sm: "max-w-2xl",
        md: "max-w-4xl",
        lg: "max-w-6xl",
        xl: "max-w-7xl",
        full: ""
      }.freeze

      PADDING_CLASSES = "px-4 py-4 sm:px-6 lg:px-8"

      TOP_OFFSET_CLASSES = {
        sm: "pt-12",
        md: "pt-16",
        lg: "pt-20",
        xl: "pt-24"
      }.freeze

      def initialize(max_width: :full, padding: :standard, top_offset: nil)
        @max_width = max_width
        @padding = padding
        @top_offset = top_offset
      end

      def classes
        tokens = []
        tokens << PADDING_CLASSES unless @padding == :none
        tokens << TOP_OFFSET_CLASSES.fetch(@top_offset) if @top_offset
        width_class = MAX_WIDTH_CLASSES.fetch(@max_width)
        tokens << width_class unless width_class.empty?
        tokens << "mx-auto" unless @max_width == :full
        tokens.join(" ")
      end
    end
  end
end
