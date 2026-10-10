# frozen_string_literal: true

module Keystone
  module Ui
    class NavigationComponent < ViewComponent::Base
      TOP_BAR_CLASSES = "hidden lg:block sticky top-0 z-40"

      renders_one :logo
      renders_one :menus

      attr_reader :groups

      def before_render
        @groups = KeystoneUi.configuration.navigation_groups
          .map { |group| [ group, group.tabs_permitted_for(helpers) ] }
          .reject { |_group, tabs| tabs.empty? }
      end
    end
  end
end
