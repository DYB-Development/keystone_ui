# frozen_string_literal: true

module Keystone
  module Ui
    class LinkComponent < ViewComponent::Base
      CLASSES = "ks-link"
      CENTRED_CLASSES = "ks-link block text-center"

      def initialize(label:, href:, centred: false)
        @label = label
        @href = href
        @centred = centred
      end

      def call
        link_to(@label, @href, class: @centred ? CENTRED_CLASSES : CLASSES)
      end
    end
  end
end
