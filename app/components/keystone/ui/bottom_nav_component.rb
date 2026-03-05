# frozen_string_literal: true

module Keystone
  module Ui
    class BottomNavComponent < ViewComponent::Base
      NAV_CLASSES = "bottom-nav lg:hidden hotwire-native:hidden"

      def nav_classes
        NAV_CLASSES
      end
    end
  end
end
