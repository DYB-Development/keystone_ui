# frozen_string_literal: true

module Keystone
  module Ui
    class PanelComponent < ViewComponent::Base
      PADDING_CLASSES = { sm: "ks-panel-padding-sm", md: "ks-panel-padding-md", lg: "ks-panel-padding-lg" }.freeze
      RADIUS_CLASSES = { md: "ks-panel-radius-md", lg: "ks-panel-radius-lg", xl: "ks-panel-radius-xl" }.freeze

      def initialize(padding: :md, radius: :lg, shadow: true)
        @padding = padding
        @radius = radius
        @shadow = shadow
      end

      BASE_CLASSES = "ks-panel"
      SHADOW_CLASS = "ks-panel-shadow"

      def classes
        tokens = [ RADIUS_CLASSES.fetch(@radius), BASE_CLASSES, PADDING_CLASSES.fetch(@padding) ]
        tokens << SHADOW_CLASS if @shadow
        tokens.join(" ")
      end
    end
  end
end
