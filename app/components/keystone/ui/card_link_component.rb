# frozen_string_literal: true

module Keystone
  module Ui
    class CardLinkComponent < ViewComponent::Base
      BASE_CLASSES = "ks-link-card block"
      SHADOW_CLASS = "shadow-sm"
      PADDING_CLASSES = { sm: "p-3", md: "p-4", lg: "p-6" }.freeze

      attr_reader :href

      def initialize(href:, padding: :md, shadow: true)
        @href = href
        @padding = padding
        @shadow = shadow
      end

      def classes
        tokens = [ BASE_CLASSES, "hover:border-accent-500/50", PADDING_CLASSES.fetch(@padding) ]
        tokens << SHADOW_CLASS if @shadow
        tokens.join(" ")
      end
    end
  end
end
