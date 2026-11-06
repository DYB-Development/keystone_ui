# frozen_string_literal: true

module Keystone
  module Ui
    class BottomNavItemComponent < ViewComponent::Base
      attr_reader :label, :href, :icon

      def initialize(label:, href:, icon:, active: false, count: nil)
        @label = label
        @href = href
        @icon = icon
        @active = active
        @count = count
      end

      ITEM_BASE = "ks-bottom-nav-item"
      ACTIVE_CLASS = "active"
      LABEL_CLASSES = "ks-bottom-nav-label"
      ICON_CLASSES = "relative"
      COUNT_CLASSES = "absolute -top-2 -right-3"

      def item_classes
        @active ? "#{ITEM_BASE} #{ACTIVE_CLASS}" : ITEM_BASE
      end

      def count_badge
        BadgeComponent.new(label: @count.to_s, variant: :info)
      end
    end
  end
end
