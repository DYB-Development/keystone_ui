# frozen_string_literal: true

module Keystone
  module Ui
    class BreadcrumbsComponent < ViewComponent::Base
      CLASSES = "ks-mobile-header-back hidden lg:block text-sm"
      SEPARATOR = "›"

      def initialize(trail:, current: nil)
        @trail = trail
        @current = current
      end
    end
  end
end
