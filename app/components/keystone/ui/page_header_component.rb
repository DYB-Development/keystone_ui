# frozen_string_literal: true

module Keystone
  module Ui
    class PageHeaderComponent < ViewComponent::Base
      WRAPPER_CLASSES = "ks-page-header"
      TITLE_CLASSES = "ks-page-header-title"
      SUBTITLE_CLASSES = "ks-page-header-subtitle"
      ACTIONS_CLASSES = "page-header-actions ks-page-header-actions"
      TITLE_ROW_CLASSES = "flex flex-wrap items-center ks-grid-gap-sm"

      attr_reader :title, :action_url, :action_label, :action_method

      def initialize(title:, subtitle: nil, action_url: nil, action_label: "Add new", action_method: nil, badges: [], class: nil)
        @title = title
        @subtitle = subtitle
        @action_url = action_url
        @action_label = action_label
        @action_method = action_method
        @badges = badges
        @action_block = nil
        @extra_classes = binding.local_variable_get(:class)
      end

      def wrapper_classes
        [ WRAPPER_CLASSES, @extra_classes ].compact.join(" ")
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
