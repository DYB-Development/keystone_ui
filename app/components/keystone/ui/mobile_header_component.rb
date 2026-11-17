# frozen_string_literal: true

module Keystone
  module Ui
    class MobileHeaderComponent < ViewComponent::Base
      BACK_ICON = <<~SVG.freeze
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
          <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5 8.25 12l7.5-7.5" />
        </svg>
      SVG

      ROW_CLASSES = "ks-page flex items-center ks-grid-gap-sm lg:hidden print:hidden max-lg:in-[.top-nav]:contents"
      WRAPPER_CLASSES = "flex items-center lg:hidden print:hidden"
      BACK_LINK_CLASSES = "ks-mobile-header-back"
      TITLE_CLASSES = "ks-mobile-header-title flex-[1_1_6rem] min-w-0 self-center lg:hidden truncate"
      SUBTITLE_CLASSES = "ks-mobile-header-subtitle block text-xs truncate"
      OVERLINE_CLASSES = "ks-mobile-header-subtitle block text-xs truncate"
      BADGE_CLASSES = "ml-auto shrink-0 self-center"

      def initialize(title:, back_url:, subtitle: nil, overline: nil, badge: nil)
        @title = title
        @back_url = back_url
        @subtitle = subtitle
        @overline = overline
        @badge = badge
      end
    end
  end
end
