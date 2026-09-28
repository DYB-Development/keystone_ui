# frozen_string_literal: true

module Keystone
  module Ui
    class CardLinkComponent < ViewComponent::Base
      BASE_CLASSES = "ks-link-card block"
      SHADOW_CLASS = "ks-link-card-shadow"
      PADDING_CLASSES = { sm: "ks-link-card-padding-sm", md: "ks-link-card-padding-md", lg: "ks-link-card-padding-lg" }.freeze

      attr_reader :href

      def initialize(href:, padding: :md, shadow: true)
        @href = href
        @padding = padding
        @shadow = shadow
      end

      def classes
        tokens = [ BASE_CLASSES, PADDING_CLASSES.fetch(@padding) ]
        tokens << SHADOW_CLASS if @shadow
        tokens.join(" ")
      end
    end
  end
end
