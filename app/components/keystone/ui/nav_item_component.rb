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

      def link_classes
        @active ? "active" : ""
      end
    end
  end
end
