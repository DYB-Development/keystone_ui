# frozen_string_literal: true

module Keystone
  module Ui
    class PageHeaderComponent < ViewComponent::Base
      WRAPPER_CLASSES = "ks-page-header"
      TITLE_CLASSES = "ks-page-header-title"
      SUBTITLE_CLASSES = "ks-page-header-subtitle"
      ACTIONS_CLASSES = "page-header-actions ks-page-header-actions"
      PHONE_WRAPPER_CLASSES = "max-sm:flex max-sm:flex-wrap max-sm:items-center max-sm:justify-between"
      MENU_ROW_CLASSES = "sm:flex items-center ks-grid-gap-sm"
      TITLE_ROW_CLASSES = "flex flex-wrap items-center ks-grid-gap-sm"

      attr_reader :title, :action_url, :action_label, :action_method

      def initialize(title:, subtitle: nil, action_url: nil, action_label: "Add new", action_method: nil, badges: [], menu: [], class: nil)
        @title = title
        @subtitle = subtitle
        @action_url = action_url
        @action_label = action_label
        @action_method = action_method
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

      def actions_classes
        [ ACTIONS_CLASSES, (MENU_ROW_CLASSES if menu?) ].compact.join(" ")
      end

      def phone?
        badges? || actions?
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
