# frozen_string_literal: true

module Keystone
  module Ui
    class MobileActionComponent < ViewComponent::Base
      LINK_CLASSES = "sm:hidden hotwire-native:hidden print:hidden"

      def render?
        content_for?(:mobile_action_url)
      end

      def call
        link_to("", content_for(:mobile_action_url), class: LINK_CLASSES, aria: { label: content_for(:mobile_action_label) })
      end
    end
  end
end
