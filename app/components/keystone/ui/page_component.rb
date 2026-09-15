# frozen_string_literal: true

module Keystone
  module Ui
    class PageComponent < ViewComponent::Base
      MAX_WIDTH_CLASSES = {
        sm: "ks-page-sm",
        md: "ks-page-md",
        lg: "ks-page-lg",
        xl: "ks-page-xl",
        full: ""
      }.freeze

      PADDING_CLASSES = "ks-page"

      TOP_OFFSET_CLASSES = {
        sm: "ks-page-offset-sm",
        md: "ks-page-offset-md",
        lg: "ks-page-offset-lg",
        xl: "ks-page-offset-xl"
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
        tokens.join(" ")
      end
    end
  end
end
