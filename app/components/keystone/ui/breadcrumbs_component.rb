# frozen_string_literal: true

module Keystone
  module Ui
    class BreadcrumbsComponent < ViewComponent::Base
      def initialize(trail:)
        @trail = trail
      end
    end
  end
end
