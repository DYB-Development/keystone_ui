# frozen_string_literal: true

module Keystone
  module Ui
    class LinkListComponent < ViewComponent::Base
      ROW_CLASSES = "ks-value-list-row items-center no-underline"
      TEXT_CLASSES = "min-w-0 flex-1"
      LABEL_CLASSES = "ks-paragraph ks-settings-link-label block"

      attr_reader :rows

      def initialize(rows:)
        @rows = rows
      end
    end
  end
end
