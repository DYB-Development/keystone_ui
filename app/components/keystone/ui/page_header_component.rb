# frozen_string_literal: true

module Keystone
  module Ui
    class PageHeaderComponent < ViewComponent::Base
      WRAPPER_CLASSES = "ks-page-header"
      TITLE_CLASSES = "ks-page-header-title"
      SUBTITLE_CLASSES = "ks-page-header-subtitle"
      ACTIONS_CLASSES = "page-header-actions ks-page-header-actions"
      PHONE_TITLE_CLASSES = "ks-page-header-title max-sm:[body:has(.ks-mobile-header-title)_&]:hidden"
      PHONE_WRAPPER_CLASSES = "max-sm:flex max-sm:flex-wrap max-sm:items-center max-sm:justify-between"
      PHONE_ACTIONS_CLASSES = "max-sm:flex max-sm:items-center max-sm:basis-full"
      ROW_CLASSES = "sm:flex sm:items-center flex-wrap max-w-full ks-grid-gap-sm"
      TITLE_ROW_CLASSES = "flex flex-wrap items-center ks-grid-gap-sm"
      MAIN_ACTION_AT_BOTTOM_CLASSES = "contents max-sm:hidden"

      attr_reader :title, :action_url, :action_label, :action_method, :action_confirm

      def initialize(title:, subtitle: nil, action_url: nil, action_label: "Add new", action_method: nil, action_confirm: nil, action_at_bottom: false, badges: [], menu: [], class: nil)
        @title = title
        @subtitle = subtitle
        @action_url = action_url
        @action_label = action_label
        @action_method = action_method
        @action_confirm = action_confirm
        @action_at_bottom = action_at_bottom
        @badges = badges
        @menu = menu
        @action_block = nil
        @extra_classes = binding.local_variable_get(:class)
      end

      def wrapper_classes
        [ WRAPPER_CLASSES, (PHONE_WRAPPER_CLASSES if phone?), @extra_classes ].compact.join(" ")
      end

      def before_render
        content
      end

      def action(&block)
        @action_block = block
      end

      def action?
        !!@action_block
      end

      def main_action_classes
        MAIN_ACTION_AT_BOTTOM_CLASSES if @action_at_bottom
      end

      def actions_classes
        [ ACTIONS_CLASSES, ROW_CLASSES, (PHONE_ACTIONS_CLASSES if phone?) ].compact.join(" ")
      end

      def title_classes
        phone? ? PHONE_TITLE_CLASSES : TITLE_CLASSES
      end

      def phone?
        badges? || menu?
      end

      def actions?
        action? || !action_url.nil? || menu?
      end

      def menu?
        @menu.any?
      end

      def badges?
        @badges.any?
      end

      def subtitle?
        !@subtitle.nil?
      end

      def subtitle_text
        @subtitle
      end
    end
  end
end
