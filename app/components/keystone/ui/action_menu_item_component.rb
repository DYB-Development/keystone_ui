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

      def question
        "#{@label} this? This cannot be undone." if @method == :delete
      end

      def call
        return link_to(@label, @href, class: ITEM_CLASSES) if @method == :get

        button_to(@href, method: @method, class: ITEM_CLASSES, form: { data: { turbo_confirm: question }.compact }) { @label }
      end
    end
  end
end
