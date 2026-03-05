# frozen_string_literal: true

module Keystone
  module Ui
    class SettingsLinkComponent < ViewComponent::Base
      attr_reader :label, :href

      LINK_CLASSES = "flex items-center justify-between px-4 py-3 text-gray-900 dark:text-gray-100 no-underline hover:bg-gray-50 dark:hover:bg-gray-800"

      CHEVRON_ICON = <<~SVG.freeze
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-5 text-gray-400">
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
