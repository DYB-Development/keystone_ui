# frozen_string_literal: true

module Keystone
  module Ui
    class NavigationComponent < ViewComponent::Base
      TOP_BAR_CLASSES = "hidden lg:block sticky top-0 z-40"
      SIDEBAR_ROW_CLASSES = "lg:flex"
      SIDEBAR_CLASSES = "ks-sidebar hidden lg:flex lg:sticky lg:top-0 lg:h-screen shrink-0 overflow-y-auto"
      SIDEBAR_GROUP_CLASSES = "flex flex-col"
      SIDEBAR_GROUP_LABEL_CLASSES = "ks-sidebar-group-label"
      SIDEBAR_TAB_CLASSES = "ks-sidebar-tab"
      SIDEBAR_MENUS_CLASSES = "mt-auto"
      SIDEBAR_CONTENT_CLASSES = "min-w-0 flex-1"
      SIDEBAR_PLACEMENTS = %w[left right].freeze

      renders_one :logo
      renders_one :menus

      attr_reader :groups

      def before_render
        @groups = KeystoneUi.configuration.navigation_groups
          .map { |group| [ group, group.tabs_permitted_for(helpers) ] }
          .reject { |_group, tabs| tabs.empty? }
        @current_tab = KeystoneUi.configuration.supplied_current_tab(helpers)
      end

      def current?(tab)
        tab.key == @current_tab
      end

      def holds_current?(tabs)
        tabs.any? { |tab| current?(tab) }
      end

      def anything_to_show?
        groups.any? || logo? || menus?
      end

      def sidebar?
        SIDEBAR_PLACEMENTS.include?(placement)
      end

      def sidebar_first?
        placement == "left"
      end

      private

      def placement
        value = KeystoneUi.configuration.supplied_preference(helpers, :navigation)&.dig(:value)
        value["placement"] if value.is_a?(Hash)
      end
    end
  end
end
