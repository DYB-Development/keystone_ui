# frozen_string_literal: true

module Keystone
  module Ui
    class DesktopBackLinkComponent < ViewComponent::Base
      def initialize(url:)
        @url = url
      end
    end
  end
end
