# frozen_string_literal: true

module Keystone
  module Ui
    class DisclosureComponent < ViewComponent::Base
      renders_one :summary

      def initialize(open: false)
        @open = open
      end

      def open?
        @open
      end
    end
  end
end
