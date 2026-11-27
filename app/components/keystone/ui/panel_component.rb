# frozen_string_literal: true

module Keystone
  module Ui
    class PanelComponent < ViewComponent::Base
      PADDING_CLASSES = { sm: "ks-panel-padding-sm", md: "ks-panel-padding-md", lg: "ks-panel-padding-lg" }.freeze
      RADIUS_CLASSES = { md: "ks-panel-radius-md", lg: "ks-panel-radius-lg", xl: "ks-panel-radius-xl" }.freeze

      def initialize(padding: :md, radius: :lg, shadow: true, shaded: false, selected: false, title: nil, selected_marker: nil)
        @padding = padding
        @radius = radius
        @shadow = shadow
        @shaded = shaded
        @selected = selected
        @title = title
        @selected_marker = selected_marker
      end

      BASE_CLASSES = "ks-panel"
      SHADOW_CLASS = "ks-panel-shadow"
      SHADED_CLASS = "ks-panel-shaded"
      SELECTED_CLASS = "ks-panel-selected"
      TITLE_CLASSES = "ks-card-title"

      attr_reader :title

      def marker
        @selected_marker if @selected
      end

      def classes
        tokens = [ RADIUS_CLASSES.fetch(@radius), BASE_CLASSES, PADDING_CLASSES.fetch(@padding) ]
        tokens << SHADOW_CLASS if @shadow && !@shaded
        tokens << SHADED_CLASS if @shaded
        tokens << SELECTED_CLASS if @selected
        tokens.join(" ")
      end
    end
  end
end
