# frozen_string_literal: true

module Keystone
  module Ui
    class ActionMenuItemComponent < ViewComponent::Base
      ITEM_CLASSES = "ks-menu-option block w-full text-left"

      def initialize(label:, href:, method: :get)
        @label = label
        @href = href
        @method = method.to_sym
      end

      def call
        link_to(@label, @href, class: ITEM_CLASSES)
      end
    end
  end
end
