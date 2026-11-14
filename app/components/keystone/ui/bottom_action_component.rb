# frozen_string_literal: true

module Keystone
  module Ui
    class BottomActionComponent < ViewComponent::Base
      BAR_CLASSES = "ks-bottom-action sm:hidden hotwire-native:hidden print:hidden"
      SPACER_CLASSES = "sm:hidden hotwire-native:hidden print:hidden"
      BAR_COPY_CLASSES = "!static invisible"
      TAB_BAR_ROOM_CLASSES = "hidden h-(--ks-bottom-nav-height) [body:has(.ks-bottom-nav)_&]:block"

      def render?
        content_for?(:mobile_action_url)
      end

      def call
        safe_join([ tag.div(class: BAR_CLASSES) { render button }, spacer ])
      end

      private

      def spacer
        tag.div(class: SPACER_CLASSES, inert: true, data: { bottom_action_spacer: true }) do
          safe_join([ tag.div(class: "#{BAR_CLASSES} #{BAR_COPY_CLASSES}") { render button }, tag.div(class: TAB_BAR_ROOM_CLASSES) ])
        end
      end

      def button
        ButtonComponent.new(label: content_for(:mobile_action_label), href: content_for(:mobile_action_url), method: action_method, confirm: content_for(:mobile_action_confirm), full_width: true)
      end

      def action_method
        content_for?(:mobile_action_method) ? content_for(:mobile_action_method).to_sym : :get
      end
    end
  end
end
