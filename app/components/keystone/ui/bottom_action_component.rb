# frozen_string_literal: true

module Keystone
  module Ui
    class BottomActionComponent < ViewComponent::Base
      BAR_CLASSES = "ks-bottom-action sm:hidden hotwire-native:hidden print:hidden"

      def render?
        content_for?(:mobile_action_url)
      end

      SPACER_CLASSES = "!static invisible [body:has(.ks-bottom-nav)_&]:mb-(--ks-bottom-nav-height)"

      def call
        safe_join([ tag.div(class: BAR_CLASSES) { render button }, spacer ])
      end

      private

      def spacer
        tag.div(class: "#{BAR_CLASSES} #{SPACER_CLASSES}", inert: true, data: { bottom_action_spacer: true }) { render button }
      end

      def button
        ButtonComponent.new(label: content_for(:mobile_action_label), href: content_for(:mobile_action_url), method: action_method, full_width: true)
      end

      def action_method
        content_for?(:mobile_action_method) ? content_for(:mobile_action_method).to_sym : :get
      end
    end
  end
end
