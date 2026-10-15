# frozen_string_literal: true

module Keystone
  module Ui
    class ValueListComponent < ViewComponent::Base
      attr_reader :rows

      def initialize(rows:)
        @rows = rows
      end

      def row_classes(row)
        [ "ks-value-list-row", ("ks-value-list-total" if row[:total]) ].compact.join(" ")
      end
    end
  end
end
