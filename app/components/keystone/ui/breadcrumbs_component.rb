# frozen_string_literal: true

module Keystone
  module Ui
    class BreadcrumbsComponent < ViewComponent::Base
      CLASSES = "hidden lg:flex items-center"
      SEPARATOR = "›"

      def initialize(trail:, current: nil)
        @trail = trail
        @current = current
      end
    end
  end
end
