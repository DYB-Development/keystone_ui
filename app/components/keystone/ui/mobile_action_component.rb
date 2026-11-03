# frozen_string_literal: true

module Keystone
  module Ui
    class MobileActionComponent < ViewComponent::Base
      PLUS_ICON = <<~SVG.freeze
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
          <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
        </svg>
      SVG

      LINK_CLASSES = "ks-action-menu-button sm:hidden hotwire-native:hidden print:hidden"

      def render?
        content_for?(:mobile_action_url)
      end

      def call
        link_to(PLUS_ICON.html_safe, content_for(:mobile_action_url), class: LINK_CLASSES, aria: { label: content_for(:mobile_action_label) })
      end
    end
  end
end
