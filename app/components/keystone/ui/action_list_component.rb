# frozen_string_literal: true

module Keystone
  module Ui
    class ActionListComponent < ViewComponent::Base
      ROW_CLASSES = "ks-value-list-row"
      TEXT_CLASSES = "min-w-0"

      attr_reader :rows

      def initialize(rows:)
        @rows = rows
      end
    end
  end
end
