# frozen_string_literal: true

module Keystone
  module Ui
    class DesktopBackLinkComponent < ViewComponent::Base
      CLASSES = "ks-mobile-header-back hidden lg:inline-flex items-center"

      def initialize(url:)
        @url = url
      end
    end
  end
end
