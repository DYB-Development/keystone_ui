# frozen_string_literal: true

module Keystone
  module Ui
    class NavItemComponent < ViewComponent::Base
      attr_reader :label, :href

      def initialize(label:, href:, active: false, count: nil)
        @label = label
        @href = href
        @active = active
        @count = count
      end

      ACTIVE_CLASS = "active"

      def link_classes
        [ "ks-nav-item", (ACTIVE_CLASS if @active) ].compact.join(" ")
      end

      def count_badge
        BadgeComponent.new(label: @count.to_s, variant: :info)
      end
    end
  end
end
