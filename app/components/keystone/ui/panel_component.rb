# frozen_string_literal: true

module Keystone
  module Ui
    class PanelComponent < ViewComponent::Base
      PADDING_CLASSES = { sm: "p-4", md: "p-5", lg: "p-6" }.freeze
      RADIUS_CLASSES = { md: "rounded-lg", lg: "rounded-xl", xl: "rounded-2xl" }.freeze

      def initialize(padding: :md, radius: :lg, shadow: true)
        @padding = padding
        @radius = radius
        @shadow = shadow
      end

      BASE_CLASSES = "ks-panel"
      SHADOW_CLASS = "shadow-sm"

      def classes
        tokens = [ RADIUS_CLASSES.fetch(@radius), BASE_CLASSES, PADDING_CLASSES.fetch(@padding) ]
        tokens << SHADOW_CLASS if @shadow
        tokens.join(" ")
      end
    end
  end
end
