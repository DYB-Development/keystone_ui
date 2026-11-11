# frozen_string_literal: true

module Keystone
  module Ui
    class LinkComponent < ViewComponent::Base
      CLASSES = "ks-link"

      def initialize(label:, href:)
        @label = label
        @href = href
      end

      def call
        link_to(@label, @href, class: CLASSES)
      end
    end
  end
end
