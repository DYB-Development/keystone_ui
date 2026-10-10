# frozen_string_literal: true

require "keystone_ui/visible_navigation"

module Keystone
  module Ui
    class NavigationComponent < ViewComponent::Base
      TOP_BAR_CLASSES = "hidden lg:block sticky top-0 z-40"
      SIDEBAR_ROW_CLASSES = "lg:flex"
      SIDEBAR_CLASSES = "ks-sidebar hidden lg:flex lg:sticky lg:top-0 lg:h-screen shrink-0 overflow-y-auto"
      SIDEBAR_LOGO_CLASSES = "ks-sidebar-logo"
      SIDEBAR_GROUP_CLASSES = "flex flex-col"
      SIDEBAR_GROUP_LABEL_CLASSES = "ks-sidebar-group-label"
      SIDEBAR_TAB_CLASSES = "ks-sidebar-tab"
      ACTIVE_CLASS = "active"
      SIDEBAR_MENUS_CLASSES = "mt-auto [&_[data-dropdown-target=menu]]:static [&_[data-controller~=dropdown]]:flex-wrap"
      SIDEBAR_CONTENT_CLASSES = "min-w-0 flex-1"
      SIDEBAR_PLACEMENTS = %w[left right].freeze

      renders_one :logo
      renders_one :menus

      attr_reader :groups

      def before_render
        @groups = KeystoneUi::VisibleNavigation.new(
          KeystoneUi.configuration.navigation_groups,
          view: helpers,
          saved_order: saved_navigation["order"] || [],
          current_tab: KeystoneUi.configuration.supplied_current_tab(helpers)
        ).groups
      end

      def sidebar_group_label_classes(group)
        [ SIDEBAR_GROUP_LABEL_CLASSES, (ACTIVE_CLASS if group.active) ].compact.join(" ")
      end

      def sidebar_tab_classes(tab)
        [ SIDEBAR_TAB_CLASSES, (ACTIVE_CLASS if tab.active) ].compact.join(" ")
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
        saved_navigation["placement"]
      end

      def saved_navigation
        value = KeystoneUi.configuration.supplied_preference(helpers, :navigation)&.dig(:value)
        value.is_a?(Hash) ? value : {}
      end
    end
  end
end
