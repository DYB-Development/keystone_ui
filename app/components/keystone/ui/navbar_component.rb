# frozen_string_literal: true

module Keystone
  module Ui
    class NavbarComponent < ViewComponent::Base
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
        classes = ["top-nav"]
        classes << "sticky top-0 z-40" if @sticky
        classes.join(" ")
      end
    end
  end
end
