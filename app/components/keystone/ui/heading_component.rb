# frozen_string_literal: true

module Keystone
  module Ui
    class HeadingComponent < ViewComponent::Base
      SIZE_CLASSES = { sm: "ks-heading-sm", md: "ks-heading-md", lg: "ks-heading-lg" }.freeze

      attr_reader :text

      def initialize(text:, size: :md)
        @text = text
        @size = size
      end

      def classes
        [ "ks-heading", SIZE_CLASSES.fetch(@size) ].join(" ")
      end
    end
  end
end
