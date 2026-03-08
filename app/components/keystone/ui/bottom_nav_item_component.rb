# frozen_string_literal: true

module Keystone
  module Ui
    class BottomNavItemComponent < ViewComponent::Base
      attr_reader :label, :href, :icon

      def initialize(label:, href:, icon:, active: false)
        @label = label
        @href = href
        @icon = icon
        @active = active
      end

      ITEM_BASE = "bottom-nav-item"
      ACTIVE_CLASS = "active"
      LABEL_CLASSES = "bottom-nav-label"

      def item_classes
        @active ? "#{ITEM_BASE} #{ACTIVE_CLASS}" : ITEM_BASE
      end
    end
  end
end
