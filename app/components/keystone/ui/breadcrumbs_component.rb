# frozen_string_literal: true

module Keystone
  module Ui
    class BreadcrumbsComponent < ViewComponent::Base
      def initialize(trail:, current: nil)
        @trail = trail
        @current = current
      end
    end
  end
end
