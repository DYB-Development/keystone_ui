# frozen_string_literal: true

module Keystone
  module Ui
    class NavItemComponent < ViewComponent::Base
      attr_reader :label, :href

      def initialize(label:, href:, active: false)
        @label = label
        @href = href
        @active = active
      end

      ACTIVE_CLASS = "active"

      def link_classes
        @active ? ACTIVE_CLASS : ""
      end
    end
  end
end
