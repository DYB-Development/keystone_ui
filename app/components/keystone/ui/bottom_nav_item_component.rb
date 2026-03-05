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

      def item_classes
        @active ? "bottom-nav-item active" : "bottom-nav-item"
      end
    end
  end
end
