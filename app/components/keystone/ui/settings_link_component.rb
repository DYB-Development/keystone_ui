# frozen_string_literal: true

module Keystone
  module Ui
    class SettingsLinkComponent < ViewComponent::Base
      LABEL_CLASSES = "ks-settings-link-label"
      attr_reader :label, :href

      LINK_CLASSES = "ks-settings-link flex items-center justify-between no-underline"

      CHEVRON_ICON = <<~SVG.freeze
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-5 ks-settings-link-chevron">
          <path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
        </svg>
      SVG

      def initialize(label:, href:)
        @label = label
        @href = href
      end

      def link_classes
        LINK_CLASSES
      end
    end
  end
end
