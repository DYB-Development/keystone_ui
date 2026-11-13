# frozen_string_literal: true

module Keystone
  module Ui
    class TimelineComponent < ViewComponent::Base
      attr_reader :entries

      def initialize(entries:)
        @entries = entries
      end
    end
  end
end
