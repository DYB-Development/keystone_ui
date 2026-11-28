# frozen_string_literal: true

module Keystone
  module Ui
    class PanelComponent < ViewComponent::Base
      PADDING_CLASSES = { sm: "ks-panel-padding-sm", md: "ks-panel-padding-md", lg: "ks-panel-padding-lg" }.freeze
      RADIUS_CLASSES = { md: "ks-panel-radius-md", lg: "ks-panel-radius-lg", xl: "ks-panel-radius-xl" }.freeze

      def initialize(padding: :md, radius: :lg, shadow: true, shaded: false, selected: false, title: nil, selected_marker: nil, aside: nil, action: nil)
        @action = action
        @padding = padding
        @radius = radius
        @shadow = shadow
        @shaded = shaded
        @selected = selected
        @title = title
        @selected_marker = selected_marker
        @aside = aside
      end

      BASE_CLASSES = "ks-panel"
      SHADOW_CLASS = "ks-panel-shadow"
      SHADED_CLASS = "ks-panel-shaded"
      SELECTED_CLASS = "ks-panel-selected"
      HEADER_CLASSES = "flex items-baseline justify-between ks-grid-gap-sm"
      TITLE_CLASSES = "ks-card-title min-w-0"
      ASIDE_CLASSES = "ks-heading-note shrink-0"
      ACTION_ROW_CLASSES = "ks-panel-action flex justify-end"
      TITLED_ACTION_CLASSES = "shrink-0"

      attr_reader :title, :aside

      def action?
        !@action.nil?
      end

      def action_button
        ButtonComponent.new(variant: :text, **@action)
      end

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
