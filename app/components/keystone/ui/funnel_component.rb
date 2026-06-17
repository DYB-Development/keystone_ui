# frozen_string_literal: true

module Keystone
  module Ui
    class FunnelComponent < ViewComponent::Base
      attr_reader :steps

      def initialize(steps:)
        @steps = steps
      end
    end
  end
end
