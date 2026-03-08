# frozen_string_literal: true

module Keystone
  module Ui
    class NavbarComponent < ViewComponent::Base
      NAV_BASE = "top-nav"
      NAV_STICKY = "sticky top-0 z-40"
      MOBILE_LEFT_CLASSES = "lg:hidden flex items-center"
      LOGO_CLASSES = "logo"
      MOBILE_CENTER_CLASSES = "absolute left-1/2 -translate-x-1/2 font-semibold text-gray-900 dark:text-white lg:hidden truncate max-w-[60%]"
      DESKTOP_LINKS_CLASSES = "nav-container hidden lg:flex"
      MOBILE_RIGHT_CLASSES = "nav-user-controls ml-auto"

      renders_one :logo
      renders_one :desktop_links
      renders_one :desktop_right
      renders_one :mobile_left
      renders_one :mobile_center
      renders_one :mobile_right

      def initialize(sticky: true)
        @sticky = sticky
      end

      def nav_classes
        classes = [NAV_BASE]
        classes << NAV_STICKY if @sticky
        classes.join(" ")
      end
    end
  end
end
