# frozen_string_literal: true

module Keystone
  module Ui
    class NavigationComponent < ViewComponent::Base
      TOP_BAR_CLASSES = "hidden lg:block sticky top-0 z-40"
      SIDEBAR_ROW_CLASSES = "lg:flex"
      SIDEBAR_CLASSES = "ks-sidebar"
      SIDEBAR_GROUP_CLASSES = "flex flex-col"
      SIDEBAR_GROUP_LABEL_CLASSES = "ks-sidebar-group-label"
      SIDEBAR_TAB_CLASSES = "ks-sidebar-tab"
      SIDEBAR_CONTENT_CLASSES = "min-w-0 flex-1"
      SIDEBAR_PLACEMENTS = %w[left right].freeze

      renders_one :logo
      renders_one :menus

      attr_reader :groups

      def before_render
        @groups = KeystoneUi.configuration.navigation_groups
          .map { |group| [ group, group.tabs_permitted_for(helpers) ] }
          .reject { |_group, tabs| tabs.empty? }
      end

      def sidebar?
        SIDEBAR_PLACEMENTS.include?(placement)
      end

      def sidebar_first?
        placement == "left"
      end

      private

      def placement
        saved = KeystoneUi.configuration.supplied_preference(helpers, :navigation)
        saved&.dig(:value, "placement")
      end
    end
  end
end
