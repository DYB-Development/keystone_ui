# frozen_string_literal: true

module Keystone
  module Ui
    class ValueListComponent < ViewComponent::Base
      attr_reader :rows

      def initialize(rows:)
        @rows = rows
      end
    end
  end
end
