# frozen_string_literal: true

module Keystone
  module Ui
    class BreadcrumbsComponent < ViewComponent::Base
      SEPARATOR = "›"

      def initialize(trail:, current: nil)
        @trail = trail
        @current = current
      end
    end
  end
end
